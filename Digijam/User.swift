//
//  User.swift
//  Digijam
//
//  Created by Joe Burgess on 11/26/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var courseName: String
    @NSManaged var firebaseID: String?
    @NSManaged var firstName: String
    @NSManaged var githubID: String
    @NSManaged var lastName: String

}
