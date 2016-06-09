//
//  AddFactViewController.swift
//  DYK
//
//  Created by Navarjun Singh on 18/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import Amplitude_iOS


class AddFactViewController: UIViewController, SuperViewController, UITextViewDelegate {
    
    static var identifier = "addFactViewController"

    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var factContentTextView: UITextView!
    
    @IBAction func buttonAction(sender: UIButton) {

        //logging submit clicked
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "submit_fact_clicked", label: "submit_fact_clicked", value: 1).build()  as [NSObject : AnyObject])
        Amplitude.instance().logEvent("submit_fact_clicked")


        // Checking the character count of the text
        if factContentTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count <= 10 {
            let alertController = UIAlertController(title: "", message: "Fact should have at least 10 characters", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        //logging fact sent
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "submit_fact", label: "submit_fact", value: 1).build()  as [NSObject : AnyObject])
        Amplitude.instance().logEvent("submit_fact")


        NetworkingHelper.sharedInstance.addFact(factContentTextView.text!,
            success: { (object) -> Void in
                let alertController = UIAlertController(title: "", message: "Yippie! Fact Submitted for Verification. Thanks!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }, failure: { (err) -> Void in
                ErrorsHelper.sharedInstance.notifyError(err, overViewController: self)
            })
    }
    
    private var initialTextViewText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialTextViewText = factContentTextView.text
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if initialTextViewText == factContentTextView.text {
            textView.text = "          "
            textView.textColor = signatureColor(1)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            textView.text = "          "
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if factContentTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            factContentTextView.text = initialTextViewText
            factContentTextView.textColor = signatureColor(0.4)
        }
    }
    
    // MARK: - Touches Ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.locationInView(view)
            
            if !containingView.frame.contains(touchLocation) {
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - Keyboard Notifications
    func keyboardWillShow(notification: NSNotification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.view.frame = CGRectMake(0, -100, self.view.frame.width, self.view.frame.height)
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        })
    }

 
//    func userFactApproved() -> Bool {
//
//        PFCloud.callFunctionInBackground("averageRatings", withParameters: ["movie":"The Matrix"]) {
//            (response: AnyObject?, error: NSError?) -> Void in
//            let ratings = response as? Float
//            // ratings is 4.5
//        }
//    }
}
