//
//  UserManager.swift
//  Digijam
//
//  Created by Zachary Drossman on 12/22/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import CoreData

class UserManager: NSObject {
    
    struct Static {
        static let instance : UserManager = UserManager()
        static var currentUser : User?
        static let dataManager : CoreDataManager = CoreDataManager.sharedInstance
    }
        
    class var sharedInstance : UserManager {
                return Static.instance
    }
    
    class func findOrCreateUserWithGithubID(githubID: String, completion: (error: NSError) -> Void) {
        if let foundUser = findUserWithGithubID(githubID) {
            Static.currentUser = foundUser
        }
        else {
            createUserWithGithubID(githubID)
            //create calls to find / create on Firebase, with success / failure returns (?)
        }
    }
    
    class func findUserWithGithubID(githubID: String) -> User? {
        
        var fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: Static.dataManager.managedObjectContext)
        
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "githubID == %@", githubID)
        fetchRequest.predicate = predicate
        
        let foundUsers = Static.dataManager.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [User]
        
        if var foundUser = foundUsers?.first {
            return foundUser
        }
        
        return nil
    }
    
    class func createUserWithGithubID(githubID: String) {
        
        var user: User = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: CoreDataManager.sharedInstance.managedObjectContext) as User
        
//        if let githubID: String = userResult["id"] as? String {
            user.githubID = githubID
//        }
        
//        if let username: String = userResult["name"] as? String {
//            
//            let startOfFirstName = username.startIndex
//            //assumes no middle name for now, can revamp this implementation to account for various names later
//            let endOfFirstName = find(username, " ")
//            let beginningOfLastName = advance(start: endOfFirstName, n: 1, nil)
//            
//            let endOfLastName = username.endIndex
//            
//            if let endOfFirstName = endOfFirstName {
//                user.firstName = username.substringWithRange(Range(start: startOfFirstName,end: endOfFirstName))
//                
//                user.lastName = username.substringWithRange(Range(start:beginningOfLastName, end: endOfLastName))
//            }
//            else {
//                //uses login (i.e. actual username) if the user's name is not complete, as a starting point.
//                if let firstName = userResult["login"] as String? {
//                    user.firstName = firstName
//                }
//            }
//        }
        
    }
    
}
