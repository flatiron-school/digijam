//
//  FirebaseAPI.swift
//  Digijam
//
//  Created by Joe Burgess on 11/18/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import Alamofire

class FirebaseAPI: NSObject {
    {




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
