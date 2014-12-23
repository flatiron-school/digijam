//
//  FirebaseAPI.swift
//  Digijam
//
//  Created by Joe Burgess on 11/18/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import Alamofire

typealias FinderComplete = (userDictionary: [String : AnyObject]?, fireBaseID: String?) -> Void
class FirebaseAPI: NSObject {


    // MARK: Finders

    class func findUserByGithubID(githubID: String, completionBlock: FinderComplete)
    {
        self.findBy("githubID", value: githubID, completionBlock: completionBlock)
    }

    class func findUserByFirebaseID(firebaseID: String, completionBlock: FinderComplete)
    {
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
        }
    }

    class func post (user : User, completionBlock: ((userID : String, success : Bool) -> Void)?)
    {
        let requestURL = NSURL(string: "\(PrivateKeys.FIREBASEURL)/users.json")
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"

        let userDictionary = ["firstName": user.firstName, "lastName": user.lastName, "courseName":user.courseName, "githubID":user.githubID]

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(userDictionary, options: nil, error: nil)

        Alamofire.request(request).responseJSON { (httpRequest, httpResponse, JSON, error) -> Void in
            if let jsonresponse : [String:String] = JSON as? [String:String]
            {
                if let completion = completionBlock
                {
                    completion(userID: jsonresponse["name"]!, success:true)
                }
            }
        }


    }
}
