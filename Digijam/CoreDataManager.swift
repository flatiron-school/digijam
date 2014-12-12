//
//  CoreDataManager.swift
//  Digijam
//
//  Created by Joe Burgess on 11/24/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager
{

    class var sharedInstance : CoreDataManager {
        struct Static {
            static let instance : CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }

    func saveContext () {
        var error: NSError? = nil
        let moc = self.managedObjectContext
        if !managedObjectContext.hasChanges {
            return
        }
        if managedObjectContext.save(&error) {
            return
        }
        
        println("Error saving context: \(error?.localizedDescription)\n\(error?.userInfo)")
        abort()
    }

    lazy var managedObjectContext: NSManagedObjectContext = {
        if let modelURL = NSBundle.mainBundle().URLForResource("Digijam", withExtension: "momd")
        {
            if let mom = NSManagedObjectModel(contentsOfURL: modelURL)
            {

                let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
                
                let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
                let storeURL = (urls[urls.endIndex-1]).URLByAppendingPathComponent("SwiftTestOne.sqlite")
                
                var error: NSError? = nil

                var store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
                if (store == nil) {
                    println("Failed to load store")
                }
                var managedObjectContext = NSManagedObjectContext()
                managedObjectContext.persistentStoreCoordinator = psc
                
                return managedObjectContext
            }
            else
            {
                println("Error getting managed object model")
                abort()
            }
        } else
        {
            println("Error getting xcdatamodeld from bundle")
            abort()

        }
        }()

}
