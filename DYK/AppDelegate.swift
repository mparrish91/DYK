//
//  AppDelegate.swift
//  DYK
//
//  Created by Navarjun Singh on 06/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import ParseTwitterUtils
import Amplitude_iOS
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        DYKFact.registerSubclass()
        DYKUserFactAction.registerSubclass()
        Parse.setApplicationId("V5eQEAOeRJD2WP4w8axQo8pYWO5FYjkC8gffTsAG", clientKey: "STUWYzhsCmQxl4plup5lq5Coshh3JdsHOxwuCi0z")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFTwitterUtils.initializeWithConsumerKey("9pGuzFvX6QOzTuaO8TMTzKvHe",  consumerSecret:"uXrPFoYxmnPvRxkgvIrZrf0y8xmtaoNhaa0dPZ0jxYrPN2dSVW")
        
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release

        
        //logging app startup
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "app_launch", label: "app_launch", value: 1).build()  as [NSObject : AnyObject])

        var apikey = "f3f3e1b0f6a7c768bf1c881f958e8cbe"
        Amplitude.instance().initializeApiKey(apikey)
        Amplitude.instance().logEvent("app_launch")


        // register for push notifications
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)

        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()


        //branch
        let branch: Branch = Branch.getInstance()
        branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            if (error == nil) {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
                // ... insert custom logic here ...
                NSLog("params: %@", params.description)
            }
            })



        
        return true
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Respond to URI scheme links
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        Branch.getInstance().handleDeepLink(url);

        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }



    // Respond to Universal Links
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        // pass the url to the handle deep link call

        return Branch.getInstance().continueUserActivity(userActivity)
    }

    //MARK: Push Notifications

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")

        let currentInstallation = PFInstallation.currentInstallation()

        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("failed to register for remote notifications:  (error)")
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }

    //iOS notification
    func dailyNotification(fact: String) {
        var notification = UILocalNotification()
        notification.alertAction = "Today's Fact!"
        notification.alertBody = fact
        notification.repeatInterval = NSCalendarUnit.NSDayCalendarUnit
        notification.fireDate = NSDate(timeIntervalSince1970: 60*60*10)

//        notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }


    func addToUserInstallationTable() {
        //grab current user for single Push to them
        if let user = PFUser.currentUser() {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.setObject((user.objectId!), forKey: "userID")
            currentInstallation.saveInBackground()
        }
    }


}

