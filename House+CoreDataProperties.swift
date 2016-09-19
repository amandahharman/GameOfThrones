//
//  House+CoreDataProperties.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/19/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import Foundation
import CoreData

extension House {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<House> {
        return NSFetchRequest<House>(entityName: "House");
    }

    @NSManaged public var name: String?
    @NSManaged public var sigil: String?
    @NSManaged public var person: NSSet?

}

// MARK: Generated accessors for person
extension House {

    @objc(addPersonObject:)
    @NSManaged public func addToPerson(_ value: Person)

    @objc(removePersonObject:)
    @NSManaged public func removeFromPerson(_ value: Person)

    @objc(addPerson:)
    @NSManaged public func addToPerson(_ values: NSSet)

    @objc(removePerson:)
    @NSManaged public func removeFromPerson(_ values: NSSet)

}
