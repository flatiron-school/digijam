//
//  GithubAPI.swift
//  Digijam
//
//  Created by Zachary Drossman on 11/13/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class GithubAPI {
    
    class func loadAccessToken () -> ([String : String]?, error : NSError?)
    {
        var service = "githubAccess"
        var accessTokenDictionary = "accessTokenDictionary"
        var userAccount = "default"
        var type : RequestType = .Read
        
        let (accessTokenData, error) = Locksmith.loadData(forKey: accessTokenDictionary, inService: service, forUserAccount: userAccount)
        
        return (accessTokenData as [String: String]?, error)
    }
    
    class func getAccessToken(githubURL: NSURL, completion:(successfullySaved: Bool) -> ()) {

        var service = "githubAccess"
        var accessTokenDictionary = "accessTokenDictionary"
        var userAccount = "default"
        var type : RequestType = .Read

        var accessCode = String( )
        
        if let tempURLString = githubURL.absoluteString {
            accessCode = tempURLString.substringWithRange(Range<String.Index>(start: advance(tempURLString.startIndex, 30), end: tempURLString.endIndex))
        }
        
        let accessTokenUrl = "https://github.com/login/oauth/access_token"
        
        let accessTokenParams = ["client_id":PrivateKeys.githubClientID, "client_secret":PrivateKeys.githubClientSecret, "code":accessCode]
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json"]
        Alamofire.request(.POST, accessTokenUrl, parameters: accessTokenParams).responseJSON({ (request, response, JSON, error) in
            
            if let accessTokenResults: [String:AnyObject] = JSON as? [String:AnyObject] {
                Locksmith.saveData(["access_token": accessTokenResults["access_token"] as String], forKey: accessTokenDictionary, inService: service, forUserAccount: userAccount)
                
                //Not really true that it was necessarily successfully saved; need to update code to do this "right", but this will check that there are at least accessTokenResults returned...
                completion(successfullySaved: true)
            }
            else {
                completion(successfullySaved: false)
            }

            
        })
    }
    
    class func getAuthenticatedUserData(completion:(githubUserDictionary: [String:AnyObject]) -> Void) {

        var user : User
        let userDetailsURL = "https://api.github.com/user?"
        Alamofire.request(.GET, userDetailsURL, parameters:GithubAPI.accessToken()).responseJSON({(request, response, JSON, error) in
            
            if let githubUserDictionary : [String:AnyObject] = JSON as? [String:AnyObject] {
                completion(githubUserDictionary: githubUserDictionary)
            }
            
        })
    }

    class func getGithubEventsForUser(username: String, completion: (githubEvents: [[String:AnyObject]]?, error: NSError!) -> ()) {
    
        let accessTokenDictionary = GithubAPI.accessToken()
        //let accessToken = accessTokenDictionary?["access_token"] Just had this in to see that the access token is returned. It is. Left here in case you want to try it.
        let feedUrl = "https://api.github.com/users/" + username + "/events"
        Alamofire.request(.GET, feedUrl, parameters:accessTokenDictionary).responseJSON({ (request, response, JSON, error) in
            if (error == nil) {
                completion(githubEvents: JSON as [[String : AnyObject]]?, error: error)
            }
        })
    }
    
    func filterPushEventsFromAPIForUser(username: String, completion: (userFeed: UserFeed?, error: NSError?) -> ()) {
        GithubAPI.getGithubEventsForUser(username) { (githubEvents, error) -> () in
            if let githubEvents = githubEvents {
                
                var userFeed = UserFeed();
                for githubEvent in githubEvents {
                    if let githubEventType: AnyObject = githubEvent["type"]
                    {
                        
                        if githubEventType as NSString  == "PushEvent" {
                            if let githubRepo: String = (githubEvent["repo"] as? [String : AnyObject])?["name"] as? String {
                                //tried to chain above. Found it to be a bit more confusing than it is worth.
                                if let githubPayload : [String : AnyObject] = githubEvent["payload"] as? [String : AnyObject] {
                                    
                                    if let githubCommits : [[String : AnyObject]] = githubPayload["commits"] as? [[String : AnyObject]] {
                                        
                                        if let lastCommitMessage : String = githubCommits[0]["message"] as? String {
                                            
                                            if let githubEventCreatedDate : String = githubEvent["created_at"] as? String {
                                            var newEvent : Event = Event(title: githubRepo, type: EventType.GithubPush, owner: UserManager.currentUser!, content:lastCommitMessage, timestamp:self.convertGithubDateStringToNSDate(githubEventCreatedDate))
                                                
                                                userFeed.events.append(newEvent)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                completion(userFeed: userFeed, error: nil) //TODO: Deal with error term.
            }
        }
    }
    
    func convertGithubDateStringToNSDate(githubDate: String) -> NSDate {
    
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

private class func accessToken() -> [String : String]? {
    
    if let githubAccessToken = GithubAPI.loadAccessToken().0 {
        return githubAccessToken
    }
    
        return nil
    }

}
