//
//  NetworkingHelper.swift
//  DYK
//
//  Created by Navarjun Singh on 18/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit

typealias ServerSuccess = ((PFObject?) -> Void)?
typealias ServerSuccessFacts = (([DYKFact]?) -> Void)?
typealias ServerFailure = ((NSError) -> Void)?

class NetworkingHelper {

    static let sharedInstance = NetworkingHelper()
    
    private func failureMessage(err: NSError?, failure: ServerFailure) {
        var error: NSError
        if err?.domain == "Parse" {
            failure?(err!)
        } else {
            error = ErrorsHelper.sharedInstance.errorObject(DYKErrorType.UnknownError)
            failure?(error)
        }
    }
    
    func login(email: String, password: String, success: ServerSuccess, failure: ServerFailure) {
        PFUser.logInWithUsernameInBackground(email, password: password) { (_, err) -> Void in
            if let err = err {
                self.failureMessage(err, failure: failure)
            } else {
                if let currentUser = PFUser.currentUser() {
                    success?(currentUser)
                } else {
                    failure?(ErrorsHelper.sharedInstance.errorObject(DYKErrorType.UnknownError))
                }
            }
        }
    }

    func logout() {
        PFUser.logOut()
    }
    
    func signup(email: String, password: String, success: ServerSuccess, failure: ServerFailure) {
        // No user exists with current email
        let newUser = PFUser()
        newUser.email = email
        newUser.password = password
        newUser.username = email
        newUser["name"] = email
        
        newUser.signUpInBackgroundWithBlock { (_, err) -> Void in
            if let err = err {
                self.failureMessage(err, failure: failure)
            } else {
                if let currentUser = PFUser.currentUser() {
                    success?(currentUser)
                } else {
                    failure?(ErrorsHelper.sharedInstance.errorObject(DYKErrorType.UnknownError))
                }
            }
        }
    }
    
    func addFact(factContent: String, success: ServerSuccess, failure: ServerFailure) {
        let fact = DYKFact(withFact: factContent)
        fact.saveInBackgroundWithBlock { (_, err) -> Void in
            if let err = err {
                self.failureMessage(err, failure: failure)
            } else {
                success?(nil)
            }
        }
    }
    
    func fetchFactsOld(success: ServerSuccessFacts, failure: ServerFailure) {
        let query = PFQuery(className: DYKFact.parseClassName())
        if let user = PFUser.currentUser() {
            query.whereKey("userId", notEqualTo: user.objectId!)
            
            // Filtering already voted facts
            let innerQuery = PFQuery(className: DYKUserFactAction.parseClassName())
            innerQuery.whereKey("userId", equalTo: user.objectId!)
            innerQuery.whereKeyExists("factId")
            query.whereKey("objectId", doesNotMatchKey: "factId", inQuery: innerQuery)
        }
        query.limit = 20
        query.whereKey("isValid", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock { (facts, err) -> Void in
            if let err = err {
                self.failureMessage(err, failure: failure)
            } else {
                if let facts = facts as? [DYKFact] {
                    success?(facts)
                } else {
                    self.failureMessage(nil, failure: failure)
                }
            }
        }
    }


    func fetchFacts(success: ServerSuccessFacts, failure: ServerFailure) {
        PFCloud.callFunctionInBackground("GetFacts", withParameters:[:]) {
            (response: AnyObject?, error: NSError?) -> Void in
            if let facts = response as? [DYKFact] {
                success?(facts)
            } else {
                self.failureMessage(nil, failure: failure)
            }

        }
    }



    
    func userAction(action: DYKUserFactActionType, onFactId factId: String, success: ServerSuccess, failure: ServerFailure) {
        var userId: String
        if let user = PFUser.currentUser() {
            userId = user.objectId!
        } else {
            let oNSUUID = UIDevice.currentDevice().identifierForVendor
            let uuidString = oNSUUID?.UUIDString
            userId = uuidString!
        }
        
        findUserActionOnFactId(factId, userId: userId, success: { (object) -> Void in
            if let userFactAction = object as? DYKUserFactAction {
                // update the object
                userFactAction.updateAction(action)
                do {
                    try userFactAction.save()
                    success?(nil)
                    
                } catch {
                    self.failureMessage(nil, failure: failure)
                }
            } else {
                self.failureMessage(nil, failure: failure)
            }
        }) { (error) -> Void in
            if error.domain == "Parse" && error.code == 101 {
                // create a new object if no object exists
                let userFactAction = DYKUserFactAction(withUserId: userId, factId: factId, action: action)
                userFactAction.saveInBackgroundWithBlock { (response, err) -> Void in
                    if let err = err {
                        self.failureMessage(err, failure: failure)
                    } else {
                        success?(nil)
                    }
                }
            } else {
                self.failureMessage(nil, failure: failure)
            }
        }
    }
    
    func getFavourites(success: ServerSuccessFacts, failure: ServerFailure) {
        var userId: String
        if let user = PFUser.currentUser() {
            userId = user.objectId!
        } else {
            let oNSUUID = UIDevice.currentDevice().identifierForVendor
            let uuidString = oNSUUID?.UUIDString
            userId = uuidString!
        }
        
        let query = PFQuery(className: DYKFact.parseClassName())
        
        // Filtering upvoted facts
        let innerQuery = PFQuery(className: DYKUserFactAction.parseClassName())
        innerQuery.whereKey("userId", equalTo: userId)
        innerQuery.whereKey("actionType", equalTo: "UPVOTE")
        innerQuery.whereKeyExists("factId")
        query.whereKey("objectId", matchesKey: "factId", inQuery: innerQuery)
        
        query.limit = 20
        query.whereKey("isValid", equalTo: true)
        
        query.findObjectsInBackgroundWithBlock { (facts, err) -> Void in
            if let err = err {
                self.failureMessage(err, failure: failure)
            } else {
                if let facts = facts as? [DYKFact] {
                    success?(facts)
                } else {
                    self.failureMessage(nil, failure: failure)
                }
            }
        }
    }
    
    private func findUserActionOnFactId(factId: String, userId: String, success: ServerSuccess, failure: ServerFailure) {
        let query = PFQuery(className: DYKUserFactAction.parseClassName())
        query.whereKey("factId", equalTo: factId)
        query.whereKey("userId", equalTo: userId)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let err = error {
                failure?(err)
            } else {
                success?(object)
            }
        }
    }
}
