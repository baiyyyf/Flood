//
//  WBPhotoDisplayData.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

class WBPhotoDisplayData: NSObject {
    var thumbnailURL: NSURL
    var gifType: Bool
    var bmiddle: Bool
    var origin: Bool
    
    var bmiddleURL: NSURL? {
        let str = thumbnailURL.absoluteString.stringByReplacingOccurrencesOfString("or360", withString: "or360")
        return bmiddle ? NSURL(string: str) : nil
    }
    
    var originalURL: NSURL? {
        let str = thumbnailURL.absoluteString.stringByReplacingOccurrencesOfString("or360", withString: "woriginal")
        return origin ? NSURL(string: str) : nil
    }
    
    init(photoURL: String, bmiddle: Bool = false, origin: Bool = false) {
        self.thumbnailURL = NSURL(string: photoURL.stringByReplacingOccurrencesOfString("thumbnail", withString: "or360")) ?? NSURL()
        self.gifType = photoURL.hasSuffix(".gif")
        self.bmiddle = bmiddle
        self.origin = origin
    }
    
    
}