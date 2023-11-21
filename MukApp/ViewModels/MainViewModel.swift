//
//  SearchViewModel.swift
//  MukApp
//
//  Created by Kang on 11/4/23.
//

import UIKit

final class MainViewModel {
    // MARK: - APIService
    private let apiService: APIServiceType
    
    // MARK: - CoreDataManager
    private let coreDataManager: CoreDataManagerType
    
    // MARK: - Init (의존성 주입)
    init(coreDataManager: CoreDataManagerType, apiServie: APIServiceType) {
        self.coreDataManager = coreDataManager
        self.apiService = apiServie
    }
    
    // MARK: - CategoryModel(싱글톤)
    private let categoryModel = CategoryModel.shared
    
    // MARK: - 데이터 모델
    // 코어 데이터 모델
    private var resDataList: [RestaurantData]?
    private var categoryDataList: [CategoryData]?
    
    // APIService 데이터 모델
    private var resultResArray: [Document] = []
    
    // MARK: - MainViewController
    // 룰렛 버튼이 눌렸을 때
    func handleRouletteTapped(fromCurrentVC: UIViewController, animated: Bool) {
        
        if categoryModel.getResListNum() == 0 {
            print("후보가 없습니다!")
            return
        }
        
        // 선택된 카테고리 배열 가져오기
        let selCatTextArray = categoryModel.getSelCatTextArray()[0]
        
        // 코어 데이터에서 selCatTextArray를 포함하는 데이터 가져오기 -> 새로운 배열로 리턴 -> 랜덤으로 출력..
        
        // 코어 데이터에서 맛집 데이터 가져오기
        resDataList = coreDataManager.getDataFromCoreData()
        
        // 옵셔널 해제
        guard let resDataList = resDataList else { return }
        
        // 해당하는 식당을 담을 빈 배열
        var resArray: [String] = []
        
        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름을 가진 카테고리 엔티티 -> 카테고리 텍스트 -> 반복문으로 할당
        for resData in resDataList {
            if let category = resData.category as? Set<CategoryData> {
                for category in category {
                    if category.categoryText == selCatTextArray {
                        guard let resName = resData.placeName else { return }
                        resArray.append(resName)
                    }
                }
            }
        }
        
        print("후보 식당: \(resArray)")
        // 랜덤으로 하나 뽑아서 메뉴 데이터에 넣기.
        var selectedMenu = resArray.randomElement() ?? "해당하는 메뉴가 없습니다."
        print("결정된 식당\(selectedMenu)")
        
        // 화면 이동 로직
        let navVC = fromCurrentVC.navigationController
        let nextVC = RouletteViewController()
        
        // TestViewController로 이동
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // 카테고리 텍스트가 결정되었을 때 -> 후보 식당 찾기
    func selCatText() {
        // 텍스트를 만족하는 ResData 가져오기
        let resultResArray = getRouletteTarget()
        
        // 후보 식당 갯수 셋
        categoryModel.setResListNum(resNum: resultResArray.count)
        
        print(resultResArray.count)
        
        for resultRes in resultResArray {
            print(resultRes.placeName ?? "데이터 없음")
        }
    }
    
    // 코어 데이터에서 CategoryName 가져오기
    func getCatNameFromCoreDataToMain() -> [String] {
        
        var catNameArray: [String] = []
        
        // 코어 데이터에서 resData 가져오기
        resDataList = coreDataManager.getDataFromCoreData()
        
        // 데이터가 없는 경우?
        guard let resDataList = resDataList else { return ["데이터 없음"] }
        
        // resData 배열 -> 카테고리 -> 카테고리 이름 => 반복문으로 할당
        for resData in resDataList {
            if let category = resData.category as? Set<CategoryData> {
                for category in category {
                    if let categoryName = category.categoryName {
                        catNameArray.append(categoryName)
                    }
                }
            }
        }
        
        // 중복된 값 제거
        catNameArray = Array(Set(catNameArray))
        
        // 카테고리 추가가 있으면 없애기
        if catNameArray.contains("카테고리 추가") {
            catNameArray.removeAll { $0 == "카테고리 추가" }
        }
        
        return catNameArray
    }
    
    // (카테고리 Name 선택 시) -> 코어 데이터에서 해당하는 CategoryText 가져오기
    func changeMainNameSelAction(item: String, completion: @escaping ([String]) -> Void) {
        // 코어 데이터에서 메뉴 데이터 가져오기
        let resDataList = coreDataManager.getDataFromCoreData()
        
        // 빈 배열로 초기화
        var catTextArray: [String] = []
        
        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름을 가진 카테고리 엔티티 -> 카테고리 텍스트 -> 반복문으로 할당
        for resData in resDataList {
            if let category = resData.category as? Set<CategoryData> {
                for category in category {
                    if category.categoryName == item {
                        guard let categoryText = category.categoryText else { return }
                        catTextArray.append(categoryText)
                    }
                }
            }
        }
        
        // 중복된 값 제거
        catTextArray = Array(Set(catTextArray))
        
        // 카테고리 추가가 있으면 없애기
        if catTextArray.contains("카테고리 추가") {
            catTextArray.removeAll { $0 == "카테고리 추가" }
        }
        
        completion(catTextArray)
    }
    
    // 플러스 버튼이 눌렸을 때
    func handleMainPlusButtonTapped() -> Bool {
        if categoryModel.plusButtonTapped() {
            print("플러스 버튼 진행시켜")
            return true
        } else {
            print("플러스 버튼 진행불가")
            return false
        }
    }
    
    // 마이너스 버튼이 눌렸을 때
    func handleMainMinusButtonTapped() {
        categoryModel.minusButtonTapped()
    }
    
    // 카테고리 선택 이벤트
    func handleMainCatNameSelAction(item: String) {
        // 데이터 저장(변경)
        self.categoryModel.setCategoryNameArray(text: item)
    }
    
    // 카테고리 텍스트 선택 이벤트
    func handleCatTextSelAction(item: String, completion: @escaping (String) -> Void) {
        // 데이터 저장
        self.categoryModel.setCategoryTextArray(text: (item))
        selCatText()
        completion(item)
    }
    
    // Next Category Name Array 리턴
    func getNextCatNameArray() -> [String] {
        return categoryModel.getNextNameArray()
    }
    
    // MARK: - ResViewController
    // 코어 데이터에서 저장된 데이터 가져오기
    func getDataFromCoreData() -> [RestaurantData] {
        let resList = coreDataManager.getDataFromCoreData()
        return resList
    }
    
    // 저장된 맛집 셀 동작
    func handleEditCellTapped(resData: RestaurantData, fromCurrentVC: UIViewController, animated: Bool) {
        let navVC = fromCurrentVC.navigationController
        let nextVC = EditResViewController(viewModel: self)
        
        // 데이터 전달
        nextVC.resData = resData
        
        // CategoryModel에 데이터 전달(나중에 코어 데이터로 저장할수도 있기 때문)
        // categoryModel.setResData(resData: resData)
        
        // TestViewController로 이동
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // "맛집 추가" 버튼 동작
    func handleAddResButtonTapped(fromCurrentVC: UIViewController, animated: Bool) {
        let navVC = fromCurrentVC.navigationController
        
        // SearchViewController로 이동
        let nextVC = SearchViewController(viewModel: self)
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // 다음 CatNameArray 정하는 로직
    func setNextCatNameArray() {
                
        let resSelDataList = getRouletteTarget()
        
        // next에 해당하는 식당 리스트의 Cat Name
        var nextCatNameArray: [String] = []
        let selCatNameArray = categoryModel.getSelCatNameArray()

        // 후보 식당 -> CatName 가져오기
        for resSelData in resSelDataList {
            print("후보 식당: \(resSelData.placeName)")
            // 카테고리 옵셔널 해제
            guard let categoryDataList = resSelData.category else { return }
            // categoryData 반복문
            for categoryData in categoryDataList as! Set<CategoryData> {
                if let categoryName = categoryData.categoryName {
                    nextCatNameArray.append(categoryName)
                    print("후보 식당: \(resSelData.placeName), 추가된 카테고리 네임: \(categoryName)")
                }
            }
        }
        
        // 중복된 값 제거
        nextCatNameArray = Array(Set(nextCatNameArray))
        print("중복값 제거 후: \(nextCatNameArray)")
        
        print("이전값: \(selCatNameArray)")
        
        // 이전 값 제거
        nextCatNameArray = nextCatNameArray.filter { !selCatNameArray.contains($0) }
        print("이전값 제거 후: \(nextCatNameArray)")
        
        // next
        categoryModel.setNextNameArray(catNameArray: nextCatNameArray)
        
        print("결과: \(nextCatNameArray)")
    }
    
    
    func getRouletteTarget() -> [RestaurantData] {
        // 선택된 카테고리 배열 가져오기
        let selCatTextArray = categoryModel.getSelCatTextArray()
        
        // 코어 데이터에서 맛집 데이터 가져오기
        let resDataList = coreDataManager.getDataFromCoreData()
        
        // 로직 (텍스트 카테고리를 모두 만족하는 resData)
        let targetResArray = resDataList.filter { resData in
            
            // resData의 CategoryList에 접근
            guard let categoryDataList = resData.category as? Set<CategoryData> else { return false }
            
            // resData의 categoryDataList가 selCatTextArray를 모두 포함하는 경우 해당 resData TRUE 리턴
            return selCatTextArray.filter { $0 != "" }.allSatisfy { selCatText in
                categoryDataList.contains { categoryData in
                    categoryData.categoryText?.contains(selCatText) ?? false
                }
            }
        }
        
        return targetResArray
    }
    
    // MARK: - EditResViewController
    func setNameDropLabel(resData: RestaurantData, completion: @escaping (_ nameArray: [String], _ textArray: [String]) -> Void) {
        
        var catNameArray: [String] = []
        var catTextArray: [String] = []
        
        print("반복문 시작 전전")
        
        if let categorySet = resData.category as? Set<CategoryData> {
            print("반복문 시작 전")
            for category in categorySet {
                if let categoryName = category.categoryName, let categoryText = category.categoryText {
                    print("categoryName = \(categoryName)")
                    print("categoryText = \(categoryText)")
                    catNameArray.append(categoryName)
                    catTextArray.append(categoryText)
                    print("반복문 끝")
                }
            }
        }
        
        completion(catNameArray, catTextArray)
    }
    
    
    // MARK: - SearchViewController
    // API 결과
    func getResArray() -> [Document] {
        return resultResArray
    }
    
    // 키워드로 API 실행하기
    func searchResFromAPI(keyword: String, completion: @escaping ([Document]) -> Void) {
        apiService.performRequest(keyword: keyword) { result in
            self.resultResArray = []
            guard let result = result else { return }
            self.resultResArray = result
            completion(self.resultResArray)
        }
    }
    
    // 검색된 맛집 Cell 동작
    func handleResCellTapped(resData: Document, fromCurrentVC: UIViewController, animated: Bool) {
        let navVC = fromCurrentVC.navigationController
        let nextVC = AddResViewController(viewModel: self)
        
        // 데이터 전달
        nextVC.resData = resData
        
        // CategoryModel에 데이터 전달(나중에 코어 데이터로 저장할수도 있기 때문)
        categoryModel.setResData(resData: resData)
        
        // TestViewController로 이동
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    
    // MARK: - AddResViewController
    // 맛집저장 버튼 동작처리(맛집 추가) -> 코어데이터에 데이터 저장
    // test로 대체됨
    func handleSaveResButtonTapped() {
        
        let resData = categoryModel.getSelResData()
        
        let categoryData = CategoryData()
        categoryData.categoryName = "잇힝"
        categoryData.categoryText = "오홍"
        
        coreDataManager.saveResToCoreData(resData: resData, categoryData: categoryData) {
            print("저장 완료")
        }
    }
    
    // MARK: - AddResTableViewCell
    // 코어 데이터에서 CategoryName 가져오기 -> catNameArray에 할당
    func getCatNameFromCoreData() -> [String] {
        
        var catNameArray: [String] = []
        
        // 코어 데이터에서 resData 가져오기
        resDataList = coreDataManager.getDataFromCoreData()
        
        // 데이터가 없는 경우?
        guard let resDataList = resDataList else { return ["데이터 없음"] }
        
        // resData 배열 -> 카테고리 -> 카테고리 이름 => 반복문으로 할당
        for resData in resDataList {
            if let category = resData.category as? Set<CategoryData> {
                for category in category {
                    if let categoryName = category.categoryName {
                        catNameArray.append(categoryName)
                    }
                }
            }
        }
        
        // 중복된 값 제거
        catNameArray = Array(Set(catNameArray))
        
        // 카테고리 추가가 없으면 더하기
        if !catNameArray.contains("카테고리 추가") {
            catNameArray.append("카테고리 추가")
        }
        
        return catNameArray
    }
    
    // 카테고리 텍스트 선택 이벤트
    func handleCatSelAction(fromVC: UIViewController, item: String, category: String, completion: @escaping (String) -> Void) {
        // 카테고리 추가 이벤트
        if item == "카테고리 추가" {
            addCatAlert(fromVC: fromVC) { saveText, save in
                // 저장
                if save {
                    guard let saveText = saveText else { return }
                    // 데이터 저장
                    self.categoryModel.setCategoryTextArray(text: saveText)
                    completion(saveText)
                }
                // 취소
                else {
                    completion("선택해주세요")
                }
            }
        }
        // 카테고리 선택 이벤트
        else {
            // 데이터 저장
            self.categoryModel.setCategoryTextArray(text: (item))
            completion(item)
        }
    }
    
    // 코어 데이터에서 CategoryText 가져오기 -> catTextArray에 할당
    func changeNameSelAction(item: String, completion: @escaping ([String]) -> Void) {
        // 코어 데이터에서 메뉴 데이터 가져오기
        let resDataList = coreDataManager.getDataFromCoreData()
        
        // 빈 배열로 초기화
        var catTextArray: [String] = []
        
        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름을 가진 카테고리 엔티티 -> 카테고리 텍스트 -> 반복문으로 할당
        for resData in resDataList {
            if let category = resData.category as? Set<CategoryData> {
                for category in category {
                    if category.categoryName == item {
                        guard let categoryText = category.categoryText else { return }
                        catTextArray.append(categoryText)
                    }
                }
            }
        }
        
        // 카테고리 추가가 없으면 더하기
        if !catTextArray.contains("카테고리 추가") {
            catTextArray.append("카테고리 추가")
        }
        
        completion(catTextArray)
    }
    
    // 카테고리 추가 얼럿창 띄우기
    private func addCatAlert(fromVC: UIViewController, completion: @escaping (String?, Bool) -> Void) {
        let alert = UIAlertController(title: "카테고리 추가", message: "추가하려는 카테고리를 입력해주세요", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "새로운 카테고리"
        }
        
        // 저장할 텍스트
        var savedText: String? = ""
        
        // alert창 1
        let save = UIAlertAction(title: "저장", style: .default) { saveAction in
            savedText = alert.textFields?[0].text
            completion(savedText, true)
        }
        
        // alert창 2
        let cancel = UIAlertAction(title: "취소", style: .default) { cancelAction in
            completion(nil, false)
        }
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        // 얼럿 창 띄우기
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 코어 데이터 테스팅
    func handeTestingCoreData() {
        
        let resData = categoryModel.getSelResData()
        let address = resData.address ?? ""
        let group = resData.group ?? ""
        let phone = resData.phone ?? ""
        let placeName = resData.placeName ?? ""
        let roadAddress = resData.roadAddress ?? ""
        let placeURL = resData.placeURL ?? ""
        
        let catNameArray = categoryModel.getSelCatNameArray()
        let catTextArray = categoryModel.getSelCatTextArray()
        
        guard catNameArray.count == catTextArray.count else {
            fatalError("The length of catNameArray and catTextArray must be the same.")
        }
        
        let categoryName = catNameArray
        let categoryText = catTextArray
        
        
        coreDataManager.testCreateCoreData(address: address, group: group, phone: phone, placeName: placeName, roadAddress: roadAddress, placeURL: placeURL, categoryName: categoryName, categoryText: categoryText) {
            print("테스트 최종 성공 텍스트")
        }
    }
    
    // MARK: - Common
    func setIsCatSelected() {
        categoryModel.setIsCatSelected()
    }
}
