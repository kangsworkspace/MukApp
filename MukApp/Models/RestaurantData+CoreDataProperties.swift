//
//  RestaurantData+CoreDataProperties.swift
//  MukApp
//
//  Created by Kang on 12/1/23.
//
//

import Foundation
import CoreData


extension RestaurantData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantData> {
        return NSFetchRequest<RestaurantData>(entityName: "RestaurantData")
    }

    @NSManaged public var address: String?
    @NSManaged public var date: Date?
    @NSManaged public var group: String?
    @NSManaged public var phone: String?
    @NSManaged public var placeName: String?
    @NSManaged public var placeURL: String?
    @NSManaged public var roadAddress: String?
    @NSManaged public var category: NSSet?

}

// MARK: Generated accessors for category
extension RestaurantData {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: CategoryData)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: CategoryData)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

extension RestaurantData : Identifiable {

}
