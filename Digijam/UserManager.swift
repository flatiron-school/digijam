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
    }
        
    class var sharedInstance : UserManager {
                return Static.instance
    }
    
    class var currentUser: User? {
        return Static.currentUser
    }
    
    class func findOrCreateUserWithGithubID(githubID: String, context: NSManagedObjectContext, completion: (error: NSError) -> Void) {
        if let foundUser = findUserWithGithubID(githubID, context: context) {
            Static.currentUser = foundUser
        }
        else {
            createUserWithGithubID(githubID, context: context)
            //create calls to find / create on Firebase, with success / failure returns (?)
        }
    }
    
    class func findUserWithGithubID(githubID: String, context: NSManagedObjectContext) -> User? {
        
        var fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "githubID == %@", githubID)
        fetchRequest.predicate = predicate
        
        let foundUsers = context.executeFetchRequest(fetchRequest, error: nil) as? [User]
        
        if var foundUser = foundUsers?.first {
            return foundUser
        }
        
        return nil
    }
    
    class func createUserWithGithubID(githubID: String, context: NSManagedObjectContext) {
        
        var user = User.insert(context)
    }
    
}
