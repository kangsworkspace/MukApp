//
//  CategoryData+CoreDataProperties.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//
//

import Foundation
import CoreData


extension CategoryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryData> {
        return NSFetchRequest<CategoryData>(entityName: "CategoryData")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var categoryText: String?
    @NSManaged public var menu: MenuData?

}

extension CategoryData : Identifiable {

}
