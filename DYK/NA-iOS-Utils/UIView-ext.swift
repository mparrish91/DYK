//
//  UIView-ext.swift
//
//  Created by Navarjun on 04/11/15.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(CGColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var rotationInDegrees: CGFloat {
        get {
            return atan2(transform.b, transform.a)
        }
        set {
            let angleInRads = newValue / 180 * CGFloat(M_PI)
            transform = CGAffineTransformRotate(transform, angleInRads)
        }
    }
    
    // MARK: - Layer Shadows
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let cgcolor = layer.shadowColor {
                return UIColor(CGColor: cgcolor)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}