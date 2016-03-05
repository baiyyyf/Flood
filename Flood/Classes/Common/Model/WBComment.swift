//
//  WBComment.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Maker

class WBComment: Maker {
    var createdAt               = ""
    var id                      = 0
    var text                    = ""
    var user: WBUserLite!
    var status: WBStatus!
    var replyComment: WBComment!
    
    override func keyToMappedKey() -> [String: String]? {
        return [
            "createdAt": "created_at",
            "replyComment": "reply_comment",
        ]
    }
}