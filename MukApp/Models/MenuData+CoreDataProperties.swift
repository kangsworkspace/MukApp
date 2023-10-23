//
//  MenuData+CoreDataProperties.swift
//  MukApp
//
//  Created by Kang on 10/22/23.
//
//

import Foundation
import CoreData


extension MenuData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuData> {
        return NSFetchRequest<MenuData>(entityName: "MenuData")
    }

    @NSManaged public var menuName: String?
    @NSManaged public var category: NSSet?

}

// MARK: Generated accessors for category
extension MenuData {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: CategoryData)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: CategoryData)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

extension MenuData : Identifiable {

}
