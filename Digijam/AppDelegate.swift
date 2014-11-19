//
//  AppDelegate.swift
//  Digijam
//
//  Created by Zachary Drossman on 11/13/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var userDefaults : NSUserDefaults = {
        let tempDefaults = NSUserDefaults.standardUserDefaults()
        return tempDefaults
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window!.backgroundColor = UIColor.whiteColor()
        
        let accessToken = userDefaults.objectForKey("access_token") as? String
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (accessToken == nil) {
            
            var loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
            
            window?.rootViewController = loginViewController
        }
            else {
                
                
                var feedViewController = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as FeedViewController

                window?.rootViewController = feedViewController
            }

        // Override point for customization after application launch.
        return true
    }
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        var accessCode = String()
        
        if let tempURLString = url.absoluteString {
            accessCode = tempURLString.substringWithRange(Range<String.Index>(start: advance(tempURLString.startIndex, 30), end: tempURLString.endIndex))
        }
        
        let accessTokenUrl = "https://github.com/login/oauth/access_token"
        
        let privateKey = PrivateKeys()
        
        let accessTokenParams = ["client_id":PrivateKeys.githubClientID, "client_secret":PrivateKeys.githubClientSecret, "code":accessCode]
        
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Accept"] = "application/json"

        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json"]
        Alamofire.request(.POST, accessTokenUrl, parameters: accessTokenParams).response({ (request, response, data, error) in
            
            var accessTokenDictionary = self.parseJSON(data as NSData)
            
            self.userDefaults.setObject(accessTokenDictionary["access_token"] as? String, forKey: "access_token")
            
            self.userDefaults.synchronize()
            
        })
        
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        var feedViewController = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as FeedViewController

        window?.rootViewController?.presentViewController(feedViewController, animated: true, completion:nil)
        
        return true
}
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var dataDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return dataDictionary
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

