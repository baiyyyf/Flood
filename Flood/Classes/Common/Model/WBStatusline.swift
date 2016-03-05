//
//  WBStatusline.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

import Maker

class WBStatusline: Maker {
    var statuses: [WBStatus] = []
    var sinceId = 0
    var maxId = 0
    
    override func keyToMappedKey() -> [String : String]? {
        return [
            "sinceId": "since_id",
            "maxId": "max_id"
        ]
    }
}