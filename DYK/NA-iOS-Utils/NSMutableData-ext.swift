//
//  NSMutableData-ext.swift
//
//  Created by Navarjun Singh on 24/07/15.
//

import Foundation

extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it convenient extension to NSMutableData.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}