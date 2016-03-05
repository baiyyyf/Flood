//
//  WBHotWord.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Maker

class WBHotWord: Maker {
    var title   = ""
    var rank    = ""
    var index   = 0
    
    override func keyToMappedKey() -> [String : String]? {
        return ["title": "desc", "rank": "desc_extr"]
    }
}