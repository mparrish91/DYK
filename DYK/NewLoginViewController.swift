//
//  NewLoginViewController.swift
//  DYK
//
//  Created by parry on 6/8/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import ParseTwitterUtils
import Amplitude_iOS


class NewLoginViewController: UIViewController {

        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onSignUpPressed(sender: AnyObject) {
        loginPrompt()
    }


    @IBAction func onFbButtonPressed(sender: AnyObject) {
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
    }


    @IBAction func onMailPressed(sender: AnyObject) {

        //signup email event
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "signup", label: "Email", value: 1).build()  as [NSObject : AnyObject])
        Amplitude.instance().logEvent("signup_email")

        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(LoginViewController.identifier) as? LoginViewController {
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }


    }


    @IBAction func onTwitterPressed(sender: AnyObject) {
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
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)


            } else {
                let alert = UIAlertController(title: "Login unsuccessful!", message: "", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Destructive, handler: nil))
            }
        }
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




}
