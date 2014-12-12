//
//  GithubAPI.swift
//  Digijam
//
//  Created by Zachary Drossman on 11/13/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

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
        
        var accessCode = String()
        
        if let tempURLString = githubURL.absoluteString {
            accessCode = tempURLString.substringWithRange(Range<String.Index>(start: advance(tempURLString.startIndex, 30), end: tempURLString.endIndex))
        }
        
        let accessTokenUrl = "https://github.com/login/oauth/access_token"
        
        let privateKey = PrivateKeys()
        
        let accessTokenParams = ["client_id":privateKey.githubClientID, "client_secret":privateKey.githubClientSecret, "code":accessCode]
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json"]
        Alamofire.request(.POST, accessTokenUrl, parameters: accessTokenParams).response({ (request, response, data, error) in
            
        var accessTokenDictionary = self.parseJSON(data as NSData)
            
        Locksmith.saveData(["access_token": accessTokenDictionary], forKey: accessTokenDictionary, inService: service, forUserAccount: userAccount)

            //self.getUserDefaults().setObject(accessTokenDictionary["access_token"] as? String, forKey: "access_token")
            
            //self.getUserDefaults().synchronize()
            
        })
    }
    
    class func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var dataDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return dataDictionary
    }

    
}
