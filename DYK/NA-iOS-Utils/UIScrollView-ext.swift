//
//  UIScrollView-ext.swift
//  DYK
//
//  Created by Navarjun Singh on 2/26/16.
//

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
