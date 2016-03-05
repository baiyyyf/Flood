//
//  WBStatus.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Maker

class WBStatus: Maker {
    var createdAt               = ""
    var id                      = 0
    var text                    = ""
    var source                  = ""
    var favorited               = false
    var repostsCount            = 0
    var commentsCount           = 0
    var attitudesCount          = 0
    var pictureURLs: [String]!
    var bmiddlePic = false
    var originalPic = false
    var user: WBUserLite!
    var retweetStatus: WBStatus!
    
    override func keyToMappedKey() -> [String: String]? {
        return [
            "createdAt": "created_at",
            "retweetStatus": "retweeted_status",
            "repostsCount": "reposts_count",
            "commentsCount": "comments_count",
            "attitudesCount": "attitudes_count",
            "bmiddlePic": "bmiddle_pic",
            "originalPic": "original_pic",
            "pictureURLs": ""
        ]
    }
    
    override func customConvert(obj: AnyObject?) {
        super.customConvert(obj)
        guard let obj = obj else { return }
        
        if let urls = ((obj["pic_urls"] as? [[String: String]])?.map { $0.values.first! }) where urls.count != 0 {
            pictureURLs = urls
        }
        bmiddlePic = obj["bmiddle_pic"] != nil
        originalPic = obj["original_pic"] != nil
        text.bf_replaceURL()
    }
}
