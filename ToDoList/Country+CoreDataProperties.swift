//
//  Country+CoreDataProperties.swift
//  ToDoList
//
//  Created by Aakash Adhikari on 6/5/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var shortName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var things: NSSet?
    
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }
    
    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
//    public var itemsArray: [Things] {
//
//        let set = things as? Set<Things> ?? []
//
//        return set.sorted {
//            $0.wrappedName < $1.wrappedName
//        }
//    }

}

// MARK: Generated accessors for things
extension Country {

    @objc(addThingsObject:)
    @NSManaged public func addToThings(_ value: Things)

    @objc(removeThingsObject:)
    @NSManaged public func removeFromThings(_ value: Things)

    @objc(addThings:)
    @NSManaged public func addToThings(_ values: NSSet)

    @objc(removeThings:)
    @NSManaged public func removeFromThings(_ values: NSSet)

}
