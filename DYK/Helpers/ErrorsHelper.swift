//
//  ErrorsHelper.swift
//  DYK
//
//  Created by Navarjun Singh on 19/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit

let DYKErrorDomain = "DYK Error Domain"

enum DYKErrorType: ErrorType {
    case UserAlreadyExists
    case UnknownError
    
    func code() -> Int {
        switch self {
        case .UserAlreadyExists:
            return 0
        case .UnknownError:
            return 420
        }
    }
    
    func errorDescription() -> String {
        switch self {
        case .UserAlreadyExists:
            return "User for this email already exists"
        case .UnknownError:
            return "Unknown Error occurred"
        }
    }
}

class ErrorsHelper: NSObject {
    
    static let sharedInstance = ErrorsHelper()
    
    func errorObject(errorType: DYKErrorType) -> NSError {
        return NSError(domain: DYKErrorDomain, code: errorType.code(), userInfo: ["NSLocalizedDescription": errorType.errorDescription()])
        
    }
    
    func notifyError(error: NSError, overViewController vc: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error.userInfo["NSLocalizedDescription"] as? String, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}
