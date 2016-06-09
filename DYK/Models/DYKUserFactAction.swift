//
//  UserFactAction.swift
//  DYK
//
//  Created by Navarjun Singh on 20/01/16.
//  Copyright © 2016 PINC. All rights reserved.
//

enum DYKUserFactActionType {
    case Upvote
    case Downvote
    case Unknown
    
    func stringVal() -> String {
        switch self {
        case .Upvote:
            return "UPVOTE"
        case .Downvote:
            return "DOWNVOTE"
        case .Unknown:
            return "UNKNOWN"
        }
    }
}

class DYKUserFactAction: PFObject, PFSubclassing {
    
    @NSManaged var userId: String?
    @NSManaged var factId: String
    @NSManaged var actionType: String
    var action: DYKUserFactActionType {
        get {
            switch actionType {
            case "UPVOTE":
                return .Upvote
                
            case "DOWNVOTE":
                return .Downvote
                
            default:
                return .Unknown
            }
        }
        set {
            actionType = newValue.stringVal()
        }
    }
    
    class func parseClassName() -> String {
        return "UserFactAction"
    }
    
    init(withUserId userId: String?, factId: String, action: DYKUserFactActionType) {
        super.init()
        self.userId = userId
        self.factId = factId
        self.action = action
    }
    
    override init() {
        super.init()
    }
    
    func updateAction(action: DYKUserFactActionType) {
        switch action {
        case .Upvote:
            setObject(DYKUserFactActionType.Upvote.stringVal(), forKey: "actionType")
            
        case .Downvote:
            setObject(DYKUserFactActionType.Downvote.stringVal(), forKey: "actionType")
            
        case .Unknown:
            setObject(DYKUserFactActionType.Unknown.stringVal(), forKey: "actionType")
        }
    }
}
