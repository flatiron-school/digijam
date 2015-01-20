//
//  Event.swift
//  Digijam
//
//  Created by Zachary Drossman on 1/19/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

import UIKit

public enum EventType : Int {
    case GithubPush = 1
    case BlogPost = 2
    case PhotoUpload = 3
}
class Event: NSObject {
    var title : String?
    var type : EventType
    var owner: User
    var content : AnyObject
    var timestamp : NSDate
    
    init(title : String?, type : EventType, owner: User, content: AnyObject, timestamp: NSDate) {
        self.title = title
        self.type = type
        self.owner = owner
        self.content = content
        self.timestamp = timestamp
    }
}
