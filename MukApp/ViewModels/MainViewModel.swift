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
    
    // MARK: - 데이터 모델
    // 코어 데이터 모델
    private var resDataList: [RestaurantData]?
    private var categoryDataList: [CategoryData]?
    
    // APIService 데이터 모델
    private var resultResArray: [Document] = []
    
    
    
    // MARK: - ResViewController
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
        let nextVC = AddResViewController()
        
        // 데이터 전달
        nextVC.resData = resData
        
        // TestViewController로 이동
        nextVC.modalPresentationStyle = .fullScreen
        navVC?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - AddResViewController
    private var catNameArray: [String] = ["testing1", "카테고리 추가"]
    private var catTextArray: [String] = []
    private var selCatName: String = ""
    private var selCatMenu: String = ""
    
    // 코어 데이터에 있는 카테고리 NameArray 가져오기
    func getCatNameArray() -> [String] {
        
//        // 코어 데이터에서 resData 가져오기
//        resDataList = coreDataManager.getDataFromCoreData()
//        
//        // 데이터가 없는 경우?
//        guard let resDataList = resDataList else { return ["레스 데이터 없움"] }
//        
//        // resData 배열 -> 카테고리 -> 카테고리 이름 => 반복문으로 할당
//        for resData in resDataList {
//            if let category = resData.category as? Set<CategoryData> {
//                for category in category {
//                    if let categoryName = category.categoryName {
//                        catNameArray.append(categoryName)
//                    }
//                }
//            }
//        }
//        
//        // 중복된 값 제거
//        catNameArray = Array(Set(catNameArray))
//        
//        // 카테고리 추가가 없으면 더하기
//        if !catNameArray.contains("카테고리 추가") {
//            catNameArray.append("카테고리 추가")
//        }
        
        return catNameArray
    }
    
    func getCatTextArray() -> [String] {
        return catTextArray
    }
    
    var isCollectionViewEnabled = true
    
    // 카테고리 Name 선택 이벤트
    func handleCategoryNamePickerView(fromVC: UIViewController, row: Int, completion: @escaping () -> Void) {
        
//        // 기존 카테고리가 없다면,, 바로 얼럿 창 띄우기
//        if catNameArray == [] {
//            addCatAlert(fromVC: fromVC) { saveText, save in
//                if save {
//                    guard let saveText = saveText else { return }
//                    self.catNameArray.insert(saveText, at: self.catNameArray.count - 1)
//                    completion()
//                }
//                // 취소
//                else {
//                    print("취소")
//                    completion()
//                }
//            }
//        }
        
        
        // 카테고리 추가 이벤트
        if catNameArray[row] == "카테고리 추가" {
            addCatAlert(fromVC: fromVC) { saveText, save in
                // 저장
                if save {
                    guard let saveText = saveText else { return }
                    self.catNameArray.insert(saveText, at: self.catNameArray.count - 1)
                    completion()
                }
                // 취소
                else {
                    print("취소")
                    completion()
                }
            }
        } 
        // 카테고리 Name 선택 이벤트
        else {
            print("선택된 카테고리: \(catNameArray[row])")
            selCatName = catNameArray[row]
            completion()
        }
    }
    
    // 카테고리 Text 선택 이벤트
    func handleCategoryTextPickerView(fromVC: UIViewController, row: Int, completion: @escaping () -> Void) {
        
        // 카테고리 추가가 없으면 더하기
        
        
        
        
        
        
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 코어 데이터에서 데이터 가져오기
    func getDataFromCoreData() {
        // 코어 데이터에서 데이터 가져오기
        resDataList = coreDataManager.getDataFromCoreData()
    }
    
    
//        // 옵셔널 해제
//        guard let menuDataList = menuDataList else { return }
//
//        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름 => 반복문으로 할당
//        for menuData in menuDataList {
//            if let category = menuData.category as? Set<CategoryData> {
//                for category in category {
//                    if let categoryName = category.categoryName {
//                        categoryArrayN.append(categoryName)
//                    }
//                }
//            }
//        }
//
//        // 중복된 값 제거
//        categoryArrayN = Array(Set(categoryArrayN))
    
    
}
