//
//  LoginViewController.swift
//  DYK
//
//  Created by Navarjun Singh on 18/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import Amplitude_iOS


class LoginViewController: UIViewController, SuperViewController {
    
    static var identifier = "loginViewController"
    
    private enum ButtonTags: Int {
        case Login      = 10
        case Signup     = 11
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func buttonAction(sender: UIButton) {
        switch sender.tag {
        case ButtonTags.Login.rawValue:
            NetworkingHelper.sharedInstance.login(emailTextField.text!, password: passwordTextField.text!,
                success: { (userObject) -> Void in

                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.addToUserInstallationTable()



                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (err) -> Void in
                    ErrorsHelper.sharedInstance.notifyError(err, overViewController: self)
                })
            
        case ButtonTags.Signup.rawValue:
            NetworkingHelper.sharedInstance.signup(emailTextField.text!, password: passwordTextField.text!,
                success: { (userObject) in


                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.addToUserInstallationTable()

                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (err) in
                    ErrorsHelper.sharedInstance.notifyError(err, overViewController: self)
                })
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
