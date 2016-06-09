//
//  Constants.swift
//  DYK
//
//  Created by Navarjun Singh on 18/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

import UIKit

enum SignUpMethod {
    case Email
    case Faceboook
    case Twitter
    case Google
    case Unknown
}

let signatureColor = { (alpha: CGFloat) -> UIColor in
    return UIColor(red: 140.0/255, green: 136.0/255, blue: 252.0/255, alpha: alpha)
}
let redColor = { (alpha: CGFloat) -> UIColor in
    return UIColor(red: 255.0/255, green: 51.0/255, blue: 102.0/255, alpha: alpha)
}
let greenColor = { (alpha: CGFloat) -> UIColor in
    return UIColor(red: 80.0/255, green: 210.0/255, blue: 194.0/255, alpha: alpha)
}
let greyColor = { (alpha: CGFloat) -> UIColor in
    return UIColor(red: 100.0/255, green: 100.0/255, blue: 100.0/255, alpha: alpha)
}