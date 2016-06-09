//
//  BaseViewController.swift
//  DYK
//
//  Created by Navarjun Singh on 10/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import ParseTwitterUtils
import Amplitude_iOS


class BaseViewController: UITabBarController, UITabBarControllerDelegate {

    let user = PFUser.currentUser()
    var button1 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Do You Know"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "Helvetica", size: 17)!]

        self.delegate = self


        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "favouritesAction")

        if let tabBarItems = tabBar.items {
            for var i = 0; i < tabBarItems.count; i++ {
                let tabBarItem = tabBarItems[i]

                var selectedImage = UIImage(named: String(format: "tab-%d-selected", i))
                let unselectedImage = UIImage(named: String(format: "tab-%d", i))

                tabBarItem.image = unselectedImage?.imageWithRenderingMode(.AlwaysOriginal)
                if selectedImage == nil {
                    selectedImage = unselectedImage
                }
                tabBarItem.selectedImage = selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
            }
        }

        let buttonImage = UIImage(named: "tab-2")
        button1 = UIButton(type: .Custom)
        button1.addTarget(self, action: "plusButtonTap", forControlEvents: UIControlEvents.TouchUpInside)
//        button1.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin
        button1.frame = CGRectMake(0.0, 0.0, (buttonImage?.size.width)!, buttonImage!.size.height)
        button1.setBackgroundImage(buttonImage, forState: .Normal)



//        [self.button1 addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.button1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//        self.button1.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//        [self.button1 setBackgroundImage:[UIImage imageNamed:@"bar_button_record"] forState:UIControlStateNormal];


        let heightDifference = buttonImage!.size.height - self.tabBar.frame.size.height
        if (heightDifference < 0) {
        button1.center = self.tabBar.center
        }else
        {
            var center = self.tabBar.center;
            center.y = center.y - heightDifference/2.0 - 0;
            self.button1.center = center;
        }

        view.addSubview(button1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func favouritesAction() {
        if let nc = storyboard?.instantiateViewControllerWithIdentifier("modalNavigationController") as? UINavigationController,
            vc = storyboard?.instantiateViewControllerWithIdentifier(FavouritesViewController.identifier) {
                
                nc.viewControllers = [vc]
                presentViewController(nc, animated: true, completion: nil)
        }
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if let index = viewControllers?.indexOf(viewController) {
            switch index {
            case 1:

                //leaderboard pressed
                let tracker = GAI.sharedInstance().defaultTracker
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "leaderboard_clicked ", label: "leaderboard_clicked ", value: 1).build()  as [NSObject : AnyObject])
                Amplitude.instance().logEvent("leaderboard_clicked ")


                return false
            case 2:
                // Add Fact
                if Utility.isUserSignedIn() {
                    if let vc = storyboard?.instantiateViewControllerWithIdentifier(AddFactViewController.identifier) as? AddFactViewController {
                        navigationController?.presentViewController(vc, animated: true, completion: nil)
                    }
                } else {
                    loginPrompt()

                    //signup event
                    let tracker = GAI.sharedInstance().defaultTracker
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup ", label: "signup ", value: 1).build()  as [NSObject : AnyObject])
                    Amplitude.instance().logEvent("signup ")


                }
                return false
                
            case 3:
                // More Facts
                return false


            case 4:
                // Settings
                if Utility.isUserSignedIn() {
                    return true
                } else {
//                    loginPrompt()
                    self.plusButtonTap()
                    return false
                }
                
            default:
                break
            }
        }
        
        return true
    }
    
    func loginPrompt() {
        let alertController = UIAlertController(title: nil, message: "Please login to use this feature. Login using:", preferredStyle: .ActionSheet)

        alertController.addAction(UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: { (action) -> Void in

            PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"]) {
                (user: PFUser?, error: NSError?) -> Void in

                //signup FB event
                let tracker = GAI.sharedInstance().defaultTracker
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup", label: "FB", value: 1).build()  as [NSObject : AnyObject])
                Amplitude.instance().logEvent("signup_FB")

                if let _ = user {
                    let alert = UIAlertController(title: "Login successful!", message: "", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Great!", style: .Default, handler: nil))

                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.addToUserInstallationTable()

                    
                } else {
                    let alert = UIAlertController(title: "Login unsuccessful!", message: "", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: nil))
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: { (action) -> Void in
            PFTwitterUtils.logInWithBlock {
                (user: PFUser?, error: NSError?) -> Void in

                //signup Twitter event
                let tracker = GAI.sharedInstance().defaultTracker
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup", label: "Twitter", value: 1).build()  as [NSObject : AnyObject])
                Amplitude.instance().logEvent("signup_twitter")

                if let _ = user {
                    let alert = UIAlertController(title: "Login successful!", message: "", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Great!", style: .Default, handler: nil))

                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                   appDelegate.addToUserInstallationTable()

                } else {
                    let alert = UIAlertController(title: "Login unsuccessful!", message: "", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: nil))
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Email", style: .Default, handler: { (action) -> Void in

            //signup email event
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup", label: "Email", value: 1).build()  as [NSObject : AnyObject])
            Amplitude.instance().logEvent("signup_email")

            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(LoginViewController.identifier) as? LoginViewController {
                self.navigationController?.presentViewController(vc, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    func sendPushNotificationToUser() {

        let responseMessage = "fdsadfsfasdaf"
        let message = responseMessage as NSString
        var data = [ "title": "Some Title",
                     "alert": message]

        let userQuery = PFUser.query()
//        query.whereKey("owner", matchesQuery: user)
        let query: PFQuery = PFInstallation.query()!
        query.whereKey("owner", matchesQuery: userQuery!)

        let push: PFPush = PFPush()
        push.setQuery(query)
        push.setData(data)
        push.sendPushInBackground()

    }


    func plusButtonTap() {
        // Add Fact
        if Utility.isUserSignedIn() {
            if let vc = storyboard?.instantiateViewControllerWithIdentifier(AddFactViewController.identifier) as? AddFactViewController {
                navigationController?.presentViewController(vc, animated: true, completion: nil)
            }
        } else {
//            loginPrompt()

            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NewLoginViewController") as? NewLoginViewController {
                self.navigationController?.presentViewController(vc, animated: true, completion: nil)
            }


            //signup event
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup ", label: "signup ", value: 1).build()  as [NSObject : AnyObject])
            Amplitude.instance().logEvent("signup ")
        }

    }


}
