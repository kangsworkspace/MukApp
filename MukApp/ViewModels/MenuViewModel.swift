//
//  MenuViewModel.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//

import UIKit

final class MenuViewModel {
    
    // MARK: - CoreDataManager
    let coreDataManager: CoreDataManagerType
    
    // MARK: - Init (의존성 주입)
    init(coreDataManager: CoreDataManagerType) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - 코어 데이터 모델
    private var menuDataList: [RestaurantData]?
    
    // MARK: - MainViewController
    private var categoryText: String = "normal"
    private var selectedMenu: String = ""
    private var categoryArrayN: [String] = []
    private var categoryArrayT: [String] = []
    
    // selectedCategoryN 값이 변화하면 selectedCategoryT 값 바꿔주기
    private var selectedCategoryN: String = "" {
        didSet {
            changeSelectedCategoryT(selectedCategoryN)
        }
    }
    
    private var selectedCategoryT: String = ""
    
    // Output
    var getCategoryText: String {
        return categoryText
    }
    
    var getSelectedMenu: String {
        return selectedMenu
    }
    
    var getCategoryArrayN: [String] {
        return categoryArrayN
    }
    
    var getCategoryArrayT: [String] {
        return categoryArrayT
    }
    
    // Input
    func setCategoryN(_ categoryN: String) {
        self.selectedCategoryN = categoryN
    }
    
    func setCategoryT(_ categoryT: String) {
        self.selectedCategoryT = categoryT
    }
    
    func handleMenuButtonTapped() {
        // 메뉴 데이터 초기화
        selectedMenu = ""
        
        // selectedCategoryT를 가진 메뉴를 받을 임시 빈배열 / 초기화
        var categoryList: [String] = []
        
        // 코어 데이터에서 데이터 가져오기
        // menuDataList = coreDataManager.getDataFromCoreData()
        
        // 옵셔널 해제
        guard let menuDataList = menuDataList else { return }

        // 메뉴 데이터 배열
        for menuData in menuDataList {
            // 카테고리
            if let category = menuData.category as? Set<CategoryData> {
                // selectedCategoryT를 가진 카테고리 엔티티
                for category in category {
                    // 카테고리 T를 가진 menuData를 찾아서 categoryList에 넣기
                    if category.categoryText == selectedCategoryT {
                        // guard let menuName = menuData.menuName else { return }
                        // categoryList.append(menuName)
                    }
                }
            }
        }

        // 랜덤으로 하나 뽑아서 메뉴 데이터에 넣기.
        selectedMenu = categoryList.randomElement() ?? "해당하는 메뉴가 없습니다."
        print(selectedMenu)
    }
    
    func getDataFromCoreData() {
//        // 코어 데이터에서 데이터 가져오기
//        menuDataList = coreDataManager.getDataFromCoreData()
//        
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
    
    func changeSelectedCategoryT(_ selectedCategoryN: String) {
        
        // 코어 데이터에서 메뉴 데이터 가져오기
        // menuDataList = coreDataManager.getDataFromCoreData()
        
        // 옵셔널 해제
        // guard let menuDataList = menuDataList else { return }
        
        // 빈 배열로 초기화
        categoryArrayT = []
        
        // 메뉴 데이터 배열 -> 카테고리 -> 카테고리 이름을 가진 카테고리 엔티티 -> 카테고리 텍스트 -> 반복문으로 할당
//        for menuData in menuDataList {
//            if let category = menuData.category as? Set<CategoryData> {
//                for category in category {
//                    if category.categoryName == selectedCategoryN {
//                        guard let categoryText = category.categoryText else { return }
//                        categoryArrayT.append(categoryText)
//                    }
//                }
//            }
//        }
    }
}
