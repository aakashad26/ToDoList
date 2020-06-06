//
//  Things+CoreDataProperties.swift
//  ToDoList
//
//  Created by Aakash Adhikari on 6/5/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.
//
//

import Foundation
import CoreData


extension Things {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Things> {
        return NSFetchRequest<Things>(entityName: "Things")
    }

    @NSManaged public var items: String?
    @NSManaged public var origin: Country?
    
//    public var wrappedName: String {
//        Things ?? "Unknown Things"
//    }

}
