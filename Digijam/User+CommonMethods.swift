//
//  User+CommonMethods.swift
//  Digijam
//
//  Created by Joe Burgess on 12/22/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

extension User {
    class func insert(context: NSManagedObjectContext) -> User
    {
        return NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as User
    }
}
