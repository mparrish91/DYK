//
//  Utility.swift
//  DYK
//
//  Created by Navarjun Singh on 18/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit

class Utility: NSObject {

    class func isUserSignedIn() -> Bool {
        if let _ = PFUser.currentUser() {
            return true
        }
        return false
    }
}
