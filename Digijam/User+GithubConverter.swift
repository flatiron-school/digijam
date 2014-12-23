//
//  User+GithubConverter.swift
//  Alamofire
//
//  Created by Zachary Drossman on 12/23/14.
//  Copyright (c) 2014 Alamofire. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    func configureWithGithubDictionary(githubDictionary: [String : AnyObject]) {

        githubID = githubDictionary["id"] as String
        
        if let name: String = githubDictionary["name"] as? String {
            
            let startOfFirstName = name.startIndex
            //assumes no middle name for now, can revamp this implementation to account for various names later
            let endOfFirstName = find(name, " ")
            let beginningOfLastName = advance(start: endOfFirstName, n: 1, nil)
            
            let endOfLastName = name.endIndex
            
            if let endOfFirstName = endOfFirstName {
                firstName = name.substringWithRange(Range(start: startOfFirstName,end: endOfFirstName))
                
                lastName = name.substringWithRange(Range(start:beginningOfLastName, end: endOfLastName))
            }
            else {
                //uses login (i.e. actual username) if the user's name is not complete, as a starting point.
                if let username = githubDictionary["login"] as String? {
                   firstName = username
                }
            }
        }

    }
}