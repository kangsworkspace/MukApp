//
//  CategoryManager.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    // 싱글톤
    static let shared = CoreDataManager()
    
    // 앱 델리게이트 받아오기
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 임시 저장소
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // 엔터티 이름(코어 데이터에 저장된 객체)
    let modelName: String = "MenuData"
    

    // MARK: - [CREATE]: 코어 데이터에 데이터 생성하기
    func saveMenuToCoreData(menuName: String, categoryName: String, categoryText: String, competion: @escaping () -> Void) {
        
        // Menu의 entity 유요한지 확인
        if let entityMenu = NSEntityDescription.entity(forEntityName: "MenuData", in: context),
           // Category의 entity 유요한지 확인
           let entityCategory = NSEntityDescription.entity(forEntityName: "CategoryData", in: context) {
            
            // 할당할 데이터를 가진 객체 생성
            if let newMenu = NSManagedObject(entity: entityMenu, insertInto: context) as? MenuData,
               let newCategory = NSManagedObject(entity: entityCategory, insertInto: context) as? CategoryData {
                
                newMenu.menuName = menuName
                newCategory.categoryName = categoryName
                newCategory.categoryText = categoryText
                
                // newMenu에 newCategory 더하기
                newMenu.addToCategory(newCategory)
                
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
            }
        }
        competion()
    }
    
    // MARK: - [READ]: 코어 데이터에 저장된 데이터 모두 읽어오기
    func getDataFromCoreData() -> [MenuData] {
        
        // 리턴할 값 빈 배열로 초기화
        var menuList: [MenuData] = []
        
        // 요청서
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        
        do {
            // 임시 저장소에서 요청서를 통해 데이터 가져오기(fetch 메서드)
            if let fetchedMenuList = try context.fetch(request) as? [MenuData] {
                menuList = fetchedMenuList
            }
        } catch {
            print("코어데이터 가져오기 실패")
        }
        return menuList
    }
    
    
    
    // MARK: - [DELETE]: 코어 데이터에 저장된 데이터 삭제하기
    func deleteFromCoreData() {
    
        
    }
}
