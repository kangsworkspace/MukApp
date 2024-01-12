//
//  CategoryData+CoreDataProperties.swift
//  MukApp
//
//  Created by Kang on 1/3/24.
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
    @NSManaged public var order: Int32
    @NSManaged public var menu: RestaurantData?

}

extension CategoryData : Identifiable {

}
