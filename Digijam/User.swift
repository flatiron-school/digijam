//
//  User.swift
//  Digijam
//
//  Created by Joe Burgess on 11/24/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var githubID: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var courseName: String

}
