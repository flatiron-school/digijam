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
    

    
    class func getAccessToken () -> ([String : String]?, error : NSError?)
    {
        var service = "githubAccess"
        var accessTokenDictionary = "accessTokenDictionary"
        var userAccount = "default"
        var type : RequestType = .Read
        
        let (accessTokenData, error) = Locksmith.loadData(forKey: accessTokenDictionary, inService: service, forUserAccount: userAccount)
        
        return (accessTokenData as [String: String]?, error)
    }
    
    class func getAccessViaURL(githubURL: NSURL) {
        
        var service = "githubAccess"
        var accessTokenDictionary = "accessTokenDictionary"
        var userAccount = "default"
        var type : RequestType = .Read
        
        var accessCode = String()
        
        if let tempURLString = githubURL.absoluteString {
            accessCode = tempURLString.substringWithRange(Range<String.Index>(start: advance(tempURLString.startIndex, 30), end: tempURLString.endIndex))
        }
        
        let accessTokenUrl = "https://github.com/login/oauth/access_token"
        
        let accessTokenParams = ["client_id":PrivateKeys.githubClientID, "client_secret":PrivateKeys.githubClientSecret, "code":accessCode]
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json"]
        Alamofire.request(.POST, accessTokenUrl, parameters: accessTokenParams).response({ (request, response, data, error) in
            
        var accessTokenResults = self.parseJSON(data as NSData)
            
        Locksmith.saveData(["access_token": accessTokenResults["access_token"] as String], forKey: accessTokenDictionary, inService: service, forUserAccount: userAccount)

            GithubAPI.getUser()
        })
    }
    
    class func getAuthenticatedUserData() {

        var user : User
        let userDetailsURL = "https://api.github.com/user?"
        let accessTokenDictionary : [String:String]? = GithubAPI.getAccessToken().0
        Alamofire.request(.GET, userDetailsURL, parameters:accessTokenDictionary ).response({(request, response, data, error) in
            
            var userResult = self.parseJSON(data as NSData)
            
            //need to check if the user is already in our datastore so we don't add duplicates here!
            
        })
    }
    
    
    class func saveUserDictionaryAsUser(githubUser: NSDictionary) {
        
    }

    class func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var dataDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return dataDictionary
    }

    
}
