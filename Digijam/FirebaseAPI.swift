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
    class func sendTestUser ()
    {
        let requestString = "\(PrivateKeys.FIREBASEURL)/users.json"
        let requestURL = NSURL(string: requestString)
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"

        let userDictionary = ["firstName": "Joe", "lastName": "Burgess"]

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(userDictionary, options: nil, error: nil)


        Alamofire.request(request).responseJSON { (request, response, JSON, error) -> Void in
            println(JSON)
        }
    }
}
