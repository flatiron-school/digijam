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
    case Error = 4
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
    
    convenience init(githubEventDictionary: [String : AnyObject]) {
        if let githubEventType: AnyObject = githubEventDictionary["type"]
        {
            
            if githubEventType as NSString  == "PushEvent" {
                if let githubRepo: String = (githubEventDictionary["repo"] as? [String : AnyObject])?["name"] as? String {
                    //tried to chain above. Found it to be a bit more confusing than it is worth.
                    if let githubPayload : [String : AnyObject] = githubEventDictionary["payload"] as? [String : AnyObject] {
                        
                        if let githubCommits : [[String : AnyObject]] = githubPayload["commits"] as? [[String : AnyObject]] {
                            
                            if let lastCommitMessage : String = githubCommits[0]["message"] as? String {
                                
                                if let githubEventCreatedDate : String = githubEventDictionary["created_at"] as? String {
                                    
                                    self.init(title: githubRepo, type: EventType.GithubPush, owner: UserManager.currentUser!, content:lastCommitMessage, timestamp:Event.convertGithubDateStringToNSDate(githubEventCreatedDate))
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.init(title: "Error", type: EventType.Error, owner: UserManager.currentUser!, content:"This update should not exist.", timestamp:NSDate())
    }
    
    class func convertGithubDateStringToNSDate(githubDate: String) -> NSDate {
        
        var dateFormatter = NSDateFormatter()
        let usLocale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.locale = usLocale
        dateFormatter.timeZone = NSTimeZone(name:"UTC")
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        
        // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssZ"
        
        let formattedDate = dateFormatter.dateFromString(githubDate)!
        return formattedDate
    }
    
}
