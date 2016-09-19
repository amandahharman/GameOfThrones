//
//  Person+CoreDataClass.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/19/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import Foundation
import CoreData


public class Person: NSManagedObject {

    var firstLetter: String{
        return String(name!.characters.first!)
    }
}
