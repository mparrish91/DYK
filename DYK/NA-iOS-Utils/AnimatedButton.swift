//
//  AnimatedButton.swift
//
//  Created by Navarjun on 4/23/15.
//
// Button animates as follows:
// when user taps it, it shrinks
// when user leaves it, it grows from shrunk state and then goes back to actual size(scale = 1)
// This class uses UIView-ext.swift
//
// Customizable properties (though this is a obj-c concept, but I am going to use it in comments anyway)
// @property animationTime - time that button takes to grow or shrink
// @property tappedScale - scale of shrunk button(or when button is tapped)
// @property untappedScale - scale of grown button(or when user leaves the touch, before it goes to actual size)
// @property tappedAlpha - alpha of button when button is tapped

import UIKit

class AnimatedButton: UIButton {
    
    private var context : UnsafeMutablePointer<Void>  = UnsafeMutablePointer()
    private var lastState = UIControlState.Normal
    
    @IBInspectable var animationTime = 0.1
    @IBInspectable var tappedScale: CGFloat = 0.9
    @IBInspectable var untappedScale: CGFloat = 1.05
    @IBInspectable var tappedAlphaDelta : CGFloat  = CGFloat(0.1)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.New, context: context)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.New, context: context)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "highlighted" && lastState != state {
            lastState = state
            switch state {
            case UIControlState.Normal:
                layer.removeAllAnimations()
                UIView.animateWithDuration(animationTime, animations: {
                    self.layer.transform = self.newScaleTransform(self.untappedScale)
                    
                    self.alpha = self.alpha + self.tappedAlphaDelta
                    }, completion: { (finished) in
                        UIView.animateWithDuration(self.animationTime, animations: {
                            self.layer.transform = self.newScaleTransform(1)
                        })
                })
            case UIControlState.Highlighted:
                layer.removeAllAnimations()
                UIView.animateWithDuration(animationTime, animations: {
                    self.alpha = self.alpha - self.tappedAlphaDelta
                    self.layer.transform = self.newScaleTransform(self.tappedScale)
                })
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlighted = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(animationTime*2*Double(NSEC_PER_SEC) + 0.1)), dispatch_get_main_queue(), {
            self.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        })
    }
    
    private func newScaleTransform(scale: CGFloat) -> CATransform3D {
        let scaleTransform = CATransform3DMakeScale(scale, scale, 1)
        let rotationTransform = CATransform3DMakeRotation(self.rotationInDegrees, 0, 0, 1)
        return CATransform3DConcat(scaleTransform, rotationTransform)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "highlighted", context: context)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
