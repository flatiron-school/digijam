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
    
    class func getAuthenticatedUserData(completion:(githubUserDictionary: NSDictionary) -> Void) {

        var user : User
        let userDetailsURL = "https://api.github.com/user?"
        Alamofire.request(.GET, userDetailsURL, parameters:GithubAPI.accessToken()).responseJSON({(request, response, JSON, error) in
            
            if let githubUserDictionary : [String:AnyObject] = JSON as? [String:AnyObject] {
                completion(githubUserDictionary: githubUserDictionary)
            }
            
        })
    }

    class func getFeedForUser(username: String) {
    
        let feedUrl = "https://api.github.com/users/" + username + "/events"
        Alamofire.request(.GET, feedUrl, parameters:GithubAPI.accessToken()).responseJSON({ (request, response, JSON, error) in
            
            var userFeed : [String : AnyObject] = JSON as [String : AnyObject]
            
            //complete method...
        })
    }
    
    private class func accessToken() -> [String : String]? {
        
        if let githubAccessToken = GithubAPI.loadAccessToken().0 {
            return githubAccessToken
        }
        
        return nil
    }
    
}
