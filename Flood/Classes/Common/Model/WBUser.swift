//
//  WBUser.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Maker

class WBUserLite: Maker {
    var id              = 0
    var screenName      = ""
    var lAvatarURL      = ""
    var verified        = false
    var verifiedType    = -1
    var status: WBStatus!
    
    override func keyToMappedKey() -> [String: String]? {
        return [
            "screenName": "screen_name",
            "lAvatarURL": "avatar_hd",
            "verifiedType": "verified_type"
        ]
    }
}

class WBUser: WBUserLite {
    var location                = ""
    var userDescription         = ""
    var following               = false
    var gender                  = ""    // m: male
    var followersCount          = 0
    var friendsCount            = 0
    var statusesCount           = 0
    var verfiedReason           = ""
    var allowAllComment         = true
    var followMe                = false
    var coverImageURL: String?
    var coverImagePhoneURL      = ""
    
    override func keyToMappedKey() -> [String: String]? {
        var myKey = [
            "userDescription": "description",
            "followersCount": "followers_count",
            "friendsCount": "friends_count",
            "statusesCount": "statuses_count",
            "verfiedReason": "verfied_reason",
            "allowAllComment": "allow_all_comment",
            "followMe": "follow_me",
            "coverImageURL": "cover_image",
            "coverImagePhoneURL": "cover_image_phone"
        ]
        if let superMappedKey = super.keyToMappedKey() {
            myKey.merge(superMappedKey)
        }
        return myKey
    }
}