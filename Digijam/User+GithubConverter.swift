//
//  User+GithubConverter.swift
//  Alamofire
//
//  Created by Zachary Drossman on 12/23/14.
//  Copyright (c) 2014 Alamofire. All rights reserved.
//

import Foundation

extension User {
    
    func configureWithGithubDictionary(githubDictionary: [String : AnyObject]) {

        githubID = String(githubDictionary["id"] as Int) //this is worth taking a look at. swift automagically figures out this could be an int, so you can't directly cast AnyObject to String!
        githubUserName = githubDictionary["login"] as String
        //converting full name into its parts for User model
        if let name: String = githubDictionary["name"] as? String {
            
            let startOfFirstName = name.startIndex
            //assumes no middle name for now, can revamp this implementation to account for various names later
            let endOfFirstName = find(name, " ")
            let beginningOfLastName = advance(name.startIndex, 1)
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