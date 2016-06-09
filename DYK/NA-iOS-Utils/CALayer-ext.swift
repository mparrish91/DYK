//
//  CALayer-ext.swift
//
//  Created by Navarjun on 4/21/15.
//
// This extension is used to provide CALayer the functionality of setting it's border color from Storyboard
// This makes easy for us as we don't have to write "View's code"(to change border color) in "Controller code"
// and makes sure that MVC is followed.
// As long as Apple doesn't do it, I saved you, use this developer!

import UIKit

private var tempRotStore = NSNumber(float: 0.0)

extension CALayer {
    
    public var borderUIColor : UIColor! {
        get {
            return UIColor(CGColor: borderColor!)
        }
        set(newValue) {
            borderColor = newValue.CGColor
        }
    }
    
    public var shadowUIColor: UIColor! {
        get {
            return UIColor(CGColor: shadowColor!)
        }
        set(newValue) {
            shadowColor = newValue.CGColor
        }
    }
    
    public var rotation : NSNumber {
        get {
            return tempRotStore
        }
        set(newValue) {
            let doubleValue = newValue.doubleValue / 180 * Double(M_PI)
            tempRotStore = NSNumber(double: doubleValue)
            transform = CATransform3DMakeRotation(CGFloat(tempRotStore), 0, 0, 1)
        }
    }
}