//
//  UserFeed.swift
//  Digijam
//
//  Created by Zachary Drossman on 1/19/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

import UIKit

class UserFeed: NSObject {
   
    var events : [Event] = [Event]()

    //this sort of sorting pattern where you have to call the method every time seem suboptimal. i guess we could use an nsnotification to make sure it is called every time there is a change to the array? what else makes sense.

    func sortEventsByTimestamp() {
        events.sort({$0.timestamp.compare($1.timestamp) == NSComparisonResult.OrderedDescending})
    }
    
}

