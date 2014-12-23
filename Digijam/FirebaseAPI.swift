//
//  FirebaseAPI.swift
//  Digijam
//
//  Created by Joe Burgess on 11/18/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import Alamofire

typealias CreatorComplete = (firebaseID : String, success : Bool) -> Void
typealias FinderComplete = (userDictionary: [String : AnyObject]?, fireBaseID: String?) -> Void

class FirebaseAPI: NSObject {


    // MARK: Finders

    class func findUserByGithubID(githubID: String, completionBlock: FinderComplete)
    {
        self.findBy("githubID", value: githubID, completionBlock: completionBlock)
    }

    class func findUserByFirebaseID(firebaseID: String, completionBlock: FinderComplete)
    {
        // the $key is to handle the fact that the firebaseID is actually the key of the dictionary which contains the data
        self.findBy("$key", value: firebaseID, completionBlock: completionBlock)
    }

    private class func findBy(key: String, value: String, completionBlock: FinderComplete)
    {
        let requestURL = "\(PrivateKeys.FIREBASEURL)/users.json"

        let requestParams: [String:AnyObject] = ["orderBy":"\"\(key)\"", "equalTo":"\"\(value)\"","limitToFirst":1]

        Alamofire.request(.GET, requestURL, parameters: requestParams, encoding: ParameterEncoding.URL).responseJSON { (httpRequest, httpResponse, JSON, error) -> Void in
            if let JSON: [String:AnyObject] = JSON as? [String:AnyObject]
            {
                if let firebaseID: String = JSON.keys.first
                {
                    var userDictionary: [String : AnyObject] = JSON[firebaseID] as [String : AnyObject]
                    completionBlock(userDictionary: userDictionary, fireBaseID: firebaseID)
                } else
                {
                    completionBlock(userDictionary: nil, fireBaseID: nil)
                }
            }
            else
            {
                println(error)
            }
        }

    }

    // MARK: Creators

    class func findOrCreateUser(userDictionary: [String : AnyObject], completionBlock: CreatorComplete)
    {
        if let githubID = userDictionary["githubID"] as? String
        {
            self.findUserByGithubID(githubID, completionBlock: { (filledUserDictionary, fireBaseID) -> Void in
                if let fireBaseID = fireBaseID{
                    completionBlock(firebaseID: fireBaseID, success: true)
                }
                else
                {
                    self.createUser(userDictionary, completionBlock: { (firebaseID, success) -> Void in
                        completionBlock(firebaseID: firebaseID, success: success)
                    })
                }
            })
        }
    }

    class func createUser (userDictionary : [String : AnyObject], completionBlock: CreatorComplete?)
    {
        let requestURL = NSURL(string: "\(PrivateKeys.FIREBASEURL)/users.json")
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(userDictionary, options: nil, error: nil)

        Alamofire.request(request).responseJSON { (httpRequest, httpResponse, JSON, error) -> Void in
            if let jsonresponse : [String:String] = JSON as? [String:String]
            {
                if let completion = completionBlock
                {
                    completion(firebaseID: jsonresponse["name"]!, success:true)
                }
            }
        }
    }
}
