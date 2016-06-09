//
//  ApiKeys.swift
//  weatheralerts
//
//  Created by Joseph Bell on 11/16/14.
//  Copyright (c) 2014 iAchieved.it LLC. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname: String) -> String {
  // Credit to the original source for this technique at
  // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
  let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
  let plist = NSDictionary(contentsOfFile:filePath!)
  
  let value:String = plist?.objectForKey(keyname) as! String
  return value
}