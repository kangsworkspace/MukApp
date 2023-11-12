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
    func saveResToCoreData(resData: Document, categoryData: [CategoryData], competion: @escaping () -> Void)
    // Read
    func getDataFromCoreData() -> [RestaurantData]
    // Update
    
    // Delete
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
    
    
    //    @NSManaged public var address: String?
    //    @NSManaged public var group: String?
    //    @NSManaged public var phone: String?
    //    @NSManaged public var placeName: String?
    
    // MARK: - [CREATE]: 코어 데이터에 데이터 생성하기
    func saveResToCoreData(resData: Document, categoryData: [CategoryData], competion: @escaping () -> Void) {
        
        // RestaurantData의 entity 유요한지 확인
        guard let entityRestaurant = NSEntityDescription.entity(forEntityName: entityName_Res, in: context) else {
            print("entityRestaurant-유효하지 않음")
            competion()
            return
        }
        
        // CategoryData의 entity 유요한지 확인
        guard let entityCategory = NSEntityDescription.entity(forEntityName: entityName_Cat, in: context) else {
            competion()
            print("entityCategory-유효하지 않음")
            return
        }
        
        // 할당할 데이터를 가진 객체 생성
        if let newRes = NSManagedObject(entity: entityRestaurant, insertInto: context) as? RestaurantData {
            // 객체에 데이터 할당
            newRes.address = resData.address
            newRes.group = resData.group
            newRes.phone = resData.phone
            newRes.placeName = resData.placeName
            newRes.roadAddress = resData.roadAddress
            newRes.placeURL = resData.placeURL
            
            // 카테고리 배열 할당
            for categoryData in categoryData {
                if let newCat = NSManagedObject(entity: entityCategory, insertInto: context) as? CategoryData {
                    
                    newCat.categoryName = categoryData.categoryName
                    newCat.categoryText = categoryData.categoryText
                    
                    // newMenu에 newCategory 더하기
                    newRes.addToCategory(newCat)
                }
            }
            
            // Save the changes to the context
            do {
                try context.save()
                print("코어 데이터 생성 성공")
                competion()
            } catch {
                print(error)
                print("코어 데이터 생성 실패")
                competion()
            }
        } else {
            print("초기화 실패")
            competion()
        }
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
    func updateCoreData(newResData: RestaurantData, competion: @escaping () -> Void) {
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName_Res)
        
        do {
            // 요청서를 통해서 데이터 가져오기
            if let fetchedResList = try context.fetch(request) as? [RestaurantData] {
                // 배열의 첫번째
                if var targetRes = fetchedResList.first {
                    
                    // 실제 데이터 재할당
                    targetRes = newResData
                    
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
    func deleteFromCoreData() {
        
        
    }
}
