//
//  DYKFact.swift
//  DYK
//
//  Created by Navarjun Singh on 20/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

class DYKFact: PFObject, PFSubclassing {
    
    @NSManaged var factContent: String
    @NSManaged var userId: String?
    @NSManaged var isValid: Bool
    var action: DYKUserFactActionType = .Unknown
    
    class func parseClassName() -> String {
        return "Fact"
    }

    init(withFact fact: String) {
        super.init()
        factContent = fact
        if Utility.isUserSignedIn() {
            userId = PFUser.currentUser()!.objectId!
        } else {
            userId = nil
        }
        isValid = false
    }
    
    override init() {
        super.init()
    }
}
