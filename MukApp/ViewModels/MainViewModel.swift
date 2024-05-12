//
//  SearchViewModel.swift
//  MukApp
//
//  Created by Kang on 11/4/23.
//

import UIKit
import SafariServices
import AVFoundation
import Photos

// 커스텀 델리게이트
protocol AddResButtonDelegate: AnyObject {
    func addResButtonActive()
}

final class MainViewModel {
    // MARK: - APIService
    private let apiService: APIServiceType
    
    // MARK: - CoreDataManager
    private let coreDataManager: CoreDataManagerType
    
    // MARK: - ImageManager
    private let imageManager: ImageManager
    
    // MARK: - Init (의존성 주입)
    init(coreDataManager: CoreDataManagerType, apiServie: APIServiceType, imageManager: ImageManager) {
        self.coreDataManager = coreDataManager
        self.apiService = apiServie
        self.imageManager = imageManager
    }
    
    // MARK: - 데이터 모델
    // 코어 데이터 모델
    private var resDataList: [RestaurantData]?
    private var categoryDataList: [CategoryData]?
    
    // APIService 데이터 모델
    private var resultResArray: [Document] = []
    
    // MARK: - MainViewController(메인 화면, 룰렛 돌리는 페이지)
    // 룰렛 버튼이 눌렸을 때
    func handleRouletteTapped(fromCurrentVC: UIViewController, selHashTagText: [String], animated: Bool) {
        // 해당되는 식당 찾기
        let targetRes = getTargetRestaurant(selHashTagText: selHashTagText)
        
        // 화면 이동 로직
        let navVC = fromCurrentVC.navigationController
        let nextVC = RouletteViewController(viewModel: self)
        
        // 데이터 전달
        nextVC.targetResDataList = targetRes
        
        // TestViewController로 이동
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // 코어 데이터에서 CategoryName 가져오기
    func getCatNameToMain() -> [String] {
        // 코어 데이터에서 CategoryNameArray 가져오기
        var catNameArray: [String] = getCatNameFromCoreData()
        
        // 태그 추가가 있으면 없애기
        if catNameArray.contains("태그 추가") {
            catNameArray.removeAll { $0 == "태그 추가" }
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
        
        // 태그 추가가 있으면 없애기
        if catTextArray.contains("태그 추가") {
            catTextArray.removeAll { $0 == "태그 추가" }
        }
        
        completion(catTextArray)
    }
    
    // 다음 CatNameArray 정하는 로직
    func getNextCatNameArray(selHashTagName: [String], selHashTagText: [String]) -> [String] {
        // 해당되는 맛집 목록
        let resSelDataList = getTargetRestaurant(selHashTagText: selHashTagText)
        
        // 리턴할 결과값 변수
        var nextCatNameArray: [String] = []
        
        // 후보 식당에 포함되는 CatName 가져오기
        for resSelData in resSelDataList {
            // 카테고리 옵셔널 해제
            guard let categoryDataList = resSelData.category else { return ["error 해당 식당 없음"]}
            // categoryData 반복문
            for categoryData in categoryDataList as! Set<CategoryData> {
                if let categoryName = categoryData.categoryName {
                    nextCatNameArray.append(categoryName)
                }
            }
        }
        
        // 중복된 값 제거
        nextCatNameArray = Array(Set(nextCatNameArray))
        
        // 이전 값 제거
        nextCatNameArray = nextCatNameArray.filter { !selHashTagName.contains($0) }
        
        return nextCatNameArray
    }
    
    // 해쉬 텍스트에 해당하는 맛집 찾는 로직
    func getTargetRestaurant(selHashTagText: [String]) -> [RestaurantData] {
        // 코어 데이터에서 맛집 데이터 가져오기
        let resDataList = coreDataManager.getDataFromCoreData()
        
        // 로직 (텍스트 카테고리를 모두 만족하는 resData)
        let targetResArray = resDataList.filter { resData in
            // resData의 CategoryList에 접근
            guard let categoryDataList = resData.category as? Set<CategoryData> else { return false }
            
            // resData의 categoryDataList가 selCatTextArray를 모두 포함하는 경우 해당 resData TRUE 리턴
            // selHashTagText 가 ""가 아닌 경우
            // selCatTextArray를 포함하는 경우
            return selHashTagText.filter { $0 != "" }.allSatisfy { selCatText in
                categoryDataList.contains { categoryData in
                    categoryData.categoryText?.contains(selCatText) ?? false
                }
            }
        }
        return targetResArray
    }
    
    // MARK: - ResViewController (맛집 추가/관리 페이지)
    // "맛집 추가" 버튼 동작 후 화면 이동
    func handleAddResButtonTapped(fromCurrentVC: UIViewController, animated: Bool) {
        let navVC = fromCurrentVC.navigationController
        
        // SearchViewController로 이동
        let nextVC = SearchViewController(viewModel: self)
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // 맛집 삭제 동작(LongPressed)
    func collectionCellLongPressed(savedResData: RestaurantData, fromVC: UIViewController, completion: @escaping () -> Void) {
        // 얼럿 창 띄우기
        addDeleteAlert(fromVC: fromVC) { delete in
            // 삭제를 눌렀을 때
            if delete {
                // 이미지 패스가 있을때만 삭제
                if let imagePath = savedResData.imagePath {
                    // 해당 이미지 삭제
                    self.imageManager.deleteFile(urlPath: imagePath)
                }
                // 삭제
                self.coreDataManager.deleteFromCoreData(savedResData: savedResData) {
                }
                completion()
                return
            } else {
                completion()
                return
            }
        }
    }
    
    // 맛집 삭제 알럿
    private func addDeleteAlert(fromVC: UIViewController, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "맛집 삭제", message: "정말 맛집을 삭제하시겠습니까?", preferredStyle: .alert)
        // alert창 1
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
            completion(false)
        }
        
        // alert창 2
        let ok = UIAlertAction(title: "삭제", style: .destructive) { saveAction in
            completion(true)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        // 얼럿 창 띄우기
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - RestaurantViewController
    // 맛집 정보 수정 (수정/추가 버튼 눌렸을 때)
    func handleUpdateResData(restaurantData: RestaurantData, catNameArray: [String], catTextArray: [String], resImage: UIImage) {
        coreDataManager.updateCoreData(savedResData: restaurantData, catNameArray: catNameArray, catTextArray: catTextArray) {
        }
        
        // 이전에 기본 이미지로 저장한 경우(기존 경로 x)
        if imageManager.readFile(urlPath: restaurantData.imagePath!) == UIImage(systemName: "person") {
            // 앨범 이미지를 저장하는 경우(경로 생성)
            if !checkCommonImage(image: resImage) {
                imageManager.createFile(urlPath: restaurantData.imagePath!, image: resImage)
            }
            // 앨범의 이미지를 저장한 경우(기존 경로 o)
        } else {
            imageManager.createFile(urlPath: restaurantData.imagePath!, image: resImage)
        }
    }
    
    // 유저가 카테고리를 선택할 때 이벤트
    func handleCatSelActionT(fromVC: UIViewController, item: String, category: String, completion: @escaping (String) -> Void) {
        // 태그 추가 이벤트
        if item == "태그 추가" {
            addCatAlert(fromVC: fromVC) { saveText, save in
                // 저장
                if save {
                    guard let saveText = saveText else { return }
                    // 데이터 저장
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
            completion(item)
        }
    }
    
    // Category Name에 해당하는 CategoryText 가져오기
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
        
        // 중복값 빼기
        catTextArray = Array(Set(catTextArray))
        
        // 태그 추가가 없으면 더하기
        if !catTextArray.contains("태그 추가") {
            catTextArray.append("태그 추가")
        }
        
        completion(catTextArray)
    }
    
    // 코어 데이터에 맛집 추가
    func addResToCoreData(restaurantData: Document, catNameArray: [String], catTextArray: [String], resImage: UIImage) {
        
        // 데이터 할당
        let address = restaurantData.address ?? ""
        let group = restaurantData.group ?? ""
        
        // 번호 에러처리
        let phone = if restaurantData.phone != "" {
            restaurantData.phone
        } else {
            "번호 정보 없음"
        }
        
        let placeName = restaurantData.placeName ?? ""
        let roadAddress = restaurantData.roadAddress ?? ""
        let placeURL = restaurantData.placeURL ?? ""
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString: String = formatter.string(from: date)
        
        // 기본 이미지가 아니면 이미지 파일 생성
        if !checkCommonImage(image: resImage) {
            imageManager.createFile(urlPath: dateString, image: resImage)
        }
        
        guard catNameArray.count == catTextArray.count else {
            fatalError("The length of catNameArray and catTextArray must be the same.")
        }
        
        coreDataManager.saveResToCoreData(address: address, group: group, phone: phone!, placeName: placeName, roadAddress: roadAddress, placeURL: placeURL, date: date, imagePath: dateString, categoryNameArray: catNameArray, categoryTextArray: catTextArray) {
        }
    }
    
    // 코어 데이터에서 카테고리 Name 리스트 가져오기
    func getCatNameToResVC() -> [String] {
        // 코어 데이터에서 CategoryNameArray 가져오기
        var catNameArray: [String] = getCatNameFromCoreData()
        
        // 태그 추가가 없으면 더하기
        if !catNameArray.contains("태그 추가") {
            catNameArray.append("태그 추가")
        }
        
        return catNameArray
    }
    
    // 태그 추가 얼럿창 띄우기
    private func addCatAlert(fromVC: UIViewController, completion: @escaping (String?, Bool) -> Void) {
        let alert = UIAlertController(title: "태그 추가", message: "추가하려는 태그를 입력해주세요", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "새로운 태그"
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
    
    // 해시태그 삭제 동작(LongPressed)
    func tableViewCellLongPressed(fromVC: UIViewController, completion: @escaping (Bool) -> Void) {
        // 얼럿 창 띄우기
        hashDeleteAlert(fromVC: fromVC) { delete in
            // 삭제를 눌렀을 때
            if delete {
                // true 전달
                completion(delete)
                return
            } else {
                // false 전달
                completion(delete)
                return
            }
        }
    }
    
    // 해시태그 삭제 알럿
    private func hashDeleteAlert(fromVC: UIViewController, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "해시태그 삭제", message: "해당 해시태그를 삭제하시겠습니까?", preferredStyle: .alert)
        // alert창 1
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
            completion(false)
        }
        
        // alert창 2
        let ok = UIAlertAction(title: "삭제", style: .destructive) { saveAction in
            completion(true)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        // 얼럿 창 띄우기
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SearchViewController (맛집 검색 페이지)
    // API 결과 리턴
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
    
    // 화면이 이동할 때 검색 데이터 초기화
    func resetResArray() {
        resultResArray = []
    }
    
    // MARK: - 화면 이동 로직
    // 루트 뷰로 돌아가기
    func goBackRootView(fromCurrentVC: UIViewController, animated: Bool) {
        // 현재 뷰 컨트롤러
        let navVC = fromCurrentVC.navigationController
        navVC?.popToRootViewController(animated: true)
    }
    
    // 룰렛이 돌아간 후 -> 결과 창으로 이동
    func goResultViewController(fromCurrentVC: UIViewController, targetRes: RestaurantData,animated: Bool) {
        let resultVC = ResultViewController(viewModel: self)
        resultVC.targetRes = targetRes
        pushToNextVC(fromCurrentVC: fromCurrentVC, nextViewController: resultVC, animated: animated)
    }
    
    // 저장된 레스토랑 컨트롤러로 이동
    func goRestaurantController(resData: RestaurantData, fromCurrentVC: UIViewController, animated: Bool) {
        // 이동할 화면
        let nextVC = RestaurantViewController(viewModel: self, imageManager: imageManager)
        // 데이터 전달
        nextVC.restaurantCoreData = resData
        // 커스텀 델리게이트
        nextVC.addResButtonDelegate = self
        // 화면 이동
        pushToNextVC(fromCurrentVC: fromCurrentVC, nextViewController: nextVC, animated: animated)
    }
    
    // 검색된 레스토랑 컨트롤러로 이동
    func goSearchedRestaurantController(resData: Document, fromCurrentVC: UIViewController, animated: Bool) {
        // 이동할 화면
        let nextVC = RestaurantViewController(viewModel: self, imageManager: imageManager)
        // 데이터 전달
        nextVC.restaurantAPIData = resData
        // 커스텀 델리게이트
        nextVC.addResButtonDelegate = self
        // 화면 이동
        pushToNextVC(fromCurrentVC: fromCurrentVC, nextViewController: nextVC, animated: true)
    }
    
    // 화면 이동 로직
    private func pushToNextVC(fromCurrentVC: UIViewController, nextViewController: UIViewController, animated: Bool) {
        // 화면 이동 로직
        let navVC = fromCurrentVC.navigationController
        
        nextViewController.modalPresentationStyle = .fullScreen
        navVC!.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - Common
    // 이미지 매니저에 저장된 사진 가져오기
    func getImageFromImageManager(restaurantData: RestaurantData) -> UIImage {
        if let imagePath = restaurantData.imagePath {
            return imageManager.readFile(urlPath: imagePath)
        } else {
            return UIImage(systemName: "person")!
        }
    }
    
    
    // 코어 데이터에서 저장된 맛집 데이터 가져오기
    func getDataFromCoreData() -> [RestaurantData] {
        let resList = coreDataManager.getDataFromCoreData()
        return resList
    }
    
    // 코어 데이터에서 CategoryName 리스트 가져오기 -> catNameArray에 할당
    private func getCatNameFromCoreData() -> [String] {
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
        return catNameArray
    }
    
    // URL 이동
    func goWebPage(url: String, fromVC: UIViewController) {
        if url != "등록된 정보가 없습니다" {
            guard let url = URL(string: url) else { return }
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .automatic
            fromVC.present(safariViewController, animated: true)
        }
    }
    
    private func checkCommonImage(image: UIImage) -> Bool {
        
        //  13개
        switch image {
        case let image where image == RestaurantImages.korean :
            return true
        case let image where image == RestaurantImages.chicken :
            return true
        case let image where image == RestaurantImages.bakery :
            return true
        case let image where image == RestaurantImages.dessertCafe :
            return true
        case let image where image == RestaurantImages.cafe :
            return true
        case let image where image == RestaurantImages.japanese :
            return true
        case let image where image == RestaurantImages.hamburger :
            return true
        case let image where image == RestaurantImages.europe :
            return true
        case let image where image == RestaurantImages.indian :
            return true
        case let image where image == RestaurantImages.chinese :
            return true
        case let image where image == RestaurantImages.asian :
            return true
        case let image where image == RestaurantImages.restaurant :
            return true
        case let image where image == RestaurantImages.alcohol :
            return true
        default:
            return false
        }
    }
}


extension MainViewModel: AddResButtonDelegate {
    func addResButtonActive() {
        resetResArray()
    }
}
