//
//  InsetsTextField.swift
//
//  Created by Navarjun on 19/08/15.
//

import UIKit

class InsetsTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 5

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }

}
