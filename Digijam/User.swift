//
//  User.swift
//  Digijam
//
//  Created by Zachary Drossman on 1/19/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var courseName: String?
    @NSManaged var lastName: String?
    @NSManaged var firstName: String?
    @NSManaged var firebaseID: String?
    @NSManaged var githubID: String
    @NSManaged var githubUserName: String

}
