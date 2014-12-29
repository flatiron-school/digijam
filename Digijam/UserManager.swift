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
        static var context = CoreDataManager.sharedInstance.managedObjectContext
    }
    
    class var sharedInstance : UserManager {
        return Static.instance
    }
    
    class var currentUser: User? {
        return Static.currentUser
    }
    
    class var defaultContext: NSManagedObjectContext {
        return Static.context
    }
    
    class func loginUser(url:NSURL, completion: (successfulLogin: Bool) -> ()) {
        GithubAPI.getAccessToken(url, completion: { (successfullySaved) -> () in
            if successfullySaved {
                GithubAPI.getAuthenticatedUserData({ (githubUserDictionary: NSDictionary) -> Void in
                    
                })
            }
        })
    }
    
    class func findOrCreateUserWithGithubDictionary(githubDictionary: [String : AnyObject], context: NSManagedObjectContext?, completion: (error: NSError) -> Void) {
        
        var contextToUse = chooseAppropriateContext(context)
        
        if let githubId = githubDictionary["id"] as? Int {
            if let foundUser = findUserWithGithubID(String(githubId), context: contextToUse) {
                Static.currentUser = foundUser
            }
            else {
                createUserWithGithubDictionary(githubDictionary, context: contextToUse)
                //create calls to find / create on Firebase, with success / failure returns (?)
            }
            
        }
    }
    
    class func findUserWithGithubID(githubID: String, context: NSManagedObjectContext?) -> User? {
        
        var contextToUse = chooseAppropriateContext(context)
        
        var fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: contextToUse)
        
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format: "githubID == %@", githubID)
        fetchRequest.predicate = predicate
        
        let foundUsers = contextToUse.executeFetchRequest(fetchRequest, error: nil) as? [User]
        
        if let foundUser = foundUsers?.first {
            return foundUser
        }
        
        return nil
    }
    
    class func createUserWithGithubDictionary(githubDictionary: [String : AnyObject], context: NSManagedObjectContext?) {
        
        var contextToUse = chooseAppropriateContext(context)
        var user = User.insert(contextToUse)
        user.configureWithGithubDictionary(githubDictionary)
    }
    
    func getFeedForUser(githubUsername: String, context: NSManagedObjectContext, completion: (error: NSError) -> Void) {
        
    }
    
    class func chooseAppropriateContext(context: NSManagedObjectContext?) -> NSManagedObjectContext {
        
        var contextToUse : NSManagedObjectContext
        
        if let context = context {
            contextToUse = context
        }
        else {
            contextToUse = defaultContext
        }
        
        return contextToUse
    }
}
