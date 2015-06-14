//
//  Credentials.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 14/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation
import CoreData

@objc(Credentials)
class Credentials: NSManagedObject {

    @NSManaged var userId: NSNumber
    @NSManaged var singleAccessToken: String

    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
