//
//  CategoryManager.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//

import UIKit
import CoreData

protocol CoreDataManagerType {
    // Create
    func saveResToCoreData(address: String, group: String, phone: String, placeName: String, roadAddress: String, placeURL: String, categoryNameArray: [String], categoryTextArray: [String], competion: @escaping () -> Void)
    
    // Read
    func getDataFromCoreData() -> [RestaurantData]
    
    // Update
    func updateCoreData(savedResData: RestaurantData, catNameArray: [String], catTextArray: [String], competion: @escaping () -> Void)
    
    // Delete
    func deleteFromCoreData(savedResData: RestaurantData, competion: @escaping () -> Void)
}


final class CoreDataManager: CoreDataManagerType {
    
    // 싱글톤
    static let shared = CoreDataManager()
    
    // 앱 델리게이트 받아오기
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 임시 저장소
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // 엔터티 이름(코어 데이터에 저장된 객체)
    let entityName_Res: String = "RestaurantData"
    let entityName_Cat: String = "CategoryData"
    
    
    // MARK: - [CREATE]: 코어 데이터에 데이터 생성하기
    func saveResToCoreData(address: String, group: String, phone: String, placeName: String, roadAddress: String, placeURL: String, categoryNameArray: [String], categoryTextArray: [String], competion: @escaping () -> Void) {
        print("코어 데이터 생성 시작")
        
        // RestaurantData의 entity 유효한지 확인
        guard let entityRestaurant = NSEntityDescription.entity(forEntityName: entityName_Res, in: context) else {
            print("entityRestaurant-유효하지 않음")
            competion()
            return
        }
        
        // CategoryData의 entity 유효한지 확인
        guard let entityCategory = NSEntityDescription.entity(forEntityName: entityName_Cat, in: context) else {
            print("entityCategory-유효하지 않음")
            competion()
            return
        }
        
        // 할당할 데이터를 가진 객체 생성
        guard let newRes = NSManagedObject(entity: entityRestaurant, insertInto: context) as? RestaurantData else {
            print("newRes 객체 생성 실패")
            competion()
            return
        }
        
        // 객체에 데이터 할당
        newRes.address = address
        newRes.group = group
        newRes.phone = phone
        newRes.placeName = placeName
        newRes.roadAddress = roadAddress
        newRes.placeURL = placeURL
        newRes.date = Date()
        print("newRes 객체에 데이터 할당 성공")
        
        // 카테고리 배열 할당
        for index in 0...categoryNameArray.count - 1 {
            
            // 할당할 데이터를 가진 객체 생성
            guard let newCat = NSManagedObject(entity: entityCategory, insertInto: context) as? CategoryData else {
                print("newCat 객체 생성 실패")
                competion()
                return
            }
            
            newCat.categoryName = categoryNameArray[index]
            newCat.categoryText = categoryTextArray[index]
            newCat.order = Int32(index)
            
            // newMenu에 newCategory 더하기
            newRes.addToCategory(newCat)
        }
        
        do {
            try context.save()
            print("코어 데이터 업데이트 성공")
            competion()
        } catch {
            print(error)
            print("코어 데이터 업데이트 실패")
            competion()
        }
        print("코어 데이터 테스트 성공")
        competion()
    }
    
    // MARK: - [READ]: 코어 데이터에 저장된 데이터 모두 읽어오기
    func getDataFromCoreData() -> [RestaurantData] {
        
        // 리턴할 값 빈 배열로 초기화
        var restaurantList: [RestaurantData] = []
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName_Res)
        
        do {
            // 임시 저장소에서 요청서를 통해 데이터 가져오기(fetch 메서드)
            if let fetchedResList = try context.fetch(request) as? [RestaurantData] {
                restaurantList = fetchedResList
            }
        } catch {
            print("코어데이터 가져오기 실패")
        }
        return restaurantList
    }
    
    // MARK: - [UPDATE]: 코어 데이터 업데이트 하기
    func updateCoreData(savedResData: RestaurantData, catNameArray: [String], catTextArray: [String], competion: @escaping () -> Void) {
        // 옵셔널 해제(타겟 식당을 찾을 조건 -> date)
        guard let date = savedResData.date else { return }

        // CategoryData의 entity 유효한지 확인
        guard let entityCategory = NSEntityDescription.entity(forEntityName: entityName_Cat, in: context) else {
            print("entityCategory-유효하지 않음")
            competion()
            return
        }
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName_Res)
        // 예상 조건 = 날짜로 찾기
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        
        do {
            // 요청서를 통해서 데이터 가져오기
            if let fetchedResList = try context.fetch(request) as? [RestaurantData] {
                // 배열의 첫번째(예상 조건 충족)
                if let targetRes = fetchedResList.first {
                    // 기존 카테고리 데이터 삭제
                    guard let categorySet = targetRes.category else { return }
                    
                    // 관계 끊기
                    targetRes.removeFromCategory(categorySet)
                    
                    // context에서 해당 객체를 삭제합니다.
                    for category in categorySet {
                        context.delete(category as! NSManagedObject)
                    }

                    // 카테고리 다시 생성하고 할당
                    for index in 0...catNameArray.count - 1 {
                        // 할당할 데이터를 가진 객체 생성
                        guard let newCat = NSManagedObject(entity: entityCategory, insertInto: context) as? CategoryData else {
                            print("newCat 객체 생성 실패")
                            competion()
                            return
                        }
                        
                        newCat.categoryName = catNameArray[index]
                        newCat.categoryText = catTextArray[index]
                        newCat.order = Int32(index)
                        
                        // newMenu에 newCategory 더하기
                        targetRes.addToCategory(newCat)
                    }
                    
                    // Save the changes to the context
                    do {
                        try context.save()
                        print("코어 데이터 업데이트 성공")
                        competion()
                    } catch {
                        print(error)
                        print("코어 데이터 업데이트 실패")
                        competion()
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - [DELETE]: 코어 데이터에 저장된 데이터 삭제하기
    func deleteFromCoreData(savedResData: RestaurantData, competion: @escaping () -> Void) {
        // 옵셔널 해제(타겟 식당을 찾을 조건 -> date)
        guard let date = savedResData.date else { return }

        // CategoryData의 entity 유효한지 확인
        guard let entityCategory = NSEntityDescription.entity(forEntityName: entityName_Cat, in: context) else {
            print("entityCategory-유효하지 않음")
            competion()
            return
        }
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName_Res)
        // 예상 조건 = 날짜로 찾기
        request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        
        do {
            // 요청서를 통해서 데이터 가져오기
            if let fetchedResList = try context.fetch(request) as? [RestaurantData] {
                // 배열의 첫번째(예상 조건 충족)
                if let targetRes = fetchedResList.first {
                    // 기존 카테고리 데이터 삭제
                    guard let categorySet = targetRes.category else { return }
                    
                    // 관계 끊기
                    targetRes.removeFromCategory(categorySet)
                    
                    // context에서 해당 객체를 삭제합니다.
                    for category in categorySet {
                        context.delete(category as! NSManagedObject)
                    }
                    
                    // context.delete(category)
                    context.delete(targetRes)
                }
                
                // Save the changes to the context
                do {
                    try context.save()
                    print("코어 데이터 삭제 성공")
                    competion()
                } catch {
                    print(error)
                    print("코어 데이터 삭제 실패")
                    competion()
                }
            }
        } catch {
            print(error)
        }
    }
}
