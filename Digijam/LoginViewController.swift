//
//  LoginViewController.swift
//  Digijam
//
//  Created by Zachary Drossman on 11/13/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func loginTapped(sender: UIButton) {
    
    let unescapedUrlString = "githubAuth://githubLogin"
        
    var escapedUrlString = unescapedUrlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let privateKey = PrivateKeys()

        let githubAuthURL = NSURL(string: "https://github.com/login/oauth/authorize?client_id=" + privateKey.githubClientID + "&client_secret=" + privateKey.githubClientSecret + "&scope=repo&redirect_uri=" + escapedUrlString!)
        
    UIApplication.sharedApplication().openURL(githubAuthURL!)
    
  }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
