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
    
    // MARK: - ResViewController
    // 코어 데이터에서 저장된 데이터 가져오기
    func getDataFromCoreData() -> [RestaurantData] {
        var resList = coreDataManager.getDataFromCoreData()
        return resList
    }
    
    
    // "맛집 추가" 버튼 동작
    func handleAddResButtonTapped(fromCurrentVC: UIViewController, animated: Bool) {
        let navVC = fromCurrentVC.navigationController
        
        // SearchViewController로 이동
        let nextVC = SearchViewController(viewModel: self)
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
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
    
    // 맛집 Cell 동작
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
    func handleSaveResButtonTapped() {
        
        let resData = categoryModel.getSelResData()
        
        let categoryData = CategoryData()
        categoryData.categoryName = "잇힝"
        categoryData.categoryText = "오홍"
        
//        categoryDataArray.categoryName = categoryModel.getSelCatNameArray()
//        categoryDataArray.categoryText = categoryModel.getSelCatTextArray()
//        let catNameArray = categoryModel.getSelCatNameArray()
//        let catTextArray = categoryModel.getSelCatTextArray()
        
//        guard catNameArray.count == catTextArray.count else {
//            // 길이가 다르면 에러 처리 또는 적절한 조치를 취할 수 있음
//            fatalError("The length of catNameArray and catTextArray must be the same.")
//        }
        
//        for index in 0..<catNameArray.count {
//            var category = CategoryData()
//            
//            category.categoryName = catNameArray[index]
//            category.categoryText = catTextArray[index]
//            
//            categoryDataArray.append(category)
//        }
   
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
    
    // 카테고리 선택 이벤트
    func handleCatSelAction(fromVC: UIViewController, item: String, category: String, completion: @escaping (String) -> Void) {
       // 카테고리 추가 이벤트
        if item == "카테고리 추가" {
            addCatAlert(fromVC: fromVC) { saveText, save in
                // 저장
                if save {
                    guard let saveText = saveText else { return }
                    // 데이터 저장
                    self.categoryModel.setCategoryArray(text: saveText, category: category)
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
            self.categoryModel.setCategoryArray(text: item, category: category)
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
}


