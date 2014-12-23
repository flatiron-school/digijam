//
//  User+FireBaseConverter.swift
//  Digijam
//
//  Created by Joe Burgess on 12/22/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

extension User {
    func toFireBaseDictionaryAndID() -> (firbaseDictionary: [String : AnyObject], firebaseID: String?)
    {
        let firebaseDictionary = ["firstName": self.firstName, "lastName": self.lastName, "courseName":self.courseName, "githubID":self.githubID];
        if let tempFirebaseID = self.firebaseID
        {
            return (firebaseDictionary, tempFirebaseID)
        } else
        {
            return (firebaseDictionary, nil)
        }
    }

    func configureWithFireBaseDictionary(firebaseDictionary: [String : AnyObject], firebaseID: String?)
    {
        firstName = firebaseDictionary["firstName"] as String
        lastName = firebaseDictionary["lastName"] as String
        courseName = firebaseDictionary["courseName"] as String
        githubID = firebaseDictionary["githubID"] as String
        self.firebaseID = firebaseID
    }
}