//
//  SettingsViewController.swift
//  DYK
//
//  Created by parry on 5/4/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit
import Amplitude_iOS


class SettingsViewController: UIViewController {


    @IBAction func onLogoutButtonPressed(sender: AnyObject) {
        NetworkingHelper.sharedInstance.logout()

        //signup  event
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("app_action", action: "log_out", label: "log_out", value: 1).build()  as [NSObject : AnyObject])
        Amplitude.instance().logEvent("log_out")
    }


}
