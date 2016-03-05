//
//  WBEmoticon.swift
//  Flood Beta
//
//  Created by byyyf on 1/24/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import UIKit

private let emoticonBundlePath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle"

/// sina default emoticons dictinonary
private let sinaMap = NSDictionary(contentsOfFile: "\(emoticonBundlePath)/\(EmoticonPackageType.Defalut.rawValue)/brief_info.plist") as! [String: String]

/// lang xiao hua emoticons dictinonary
private let lxhMap = NSDictionary(contentsOfFile: "\(emoticonBundlePath)/\(EmoticonPackageType.Lxh.rawValue)/brief_info.plist") as! [String: String]

enum EmoticonPackageType: String {
    case Recent
    case Defalut = "com.sina.default"
    case Lxh = "com.sina.lxh"
}

public class WBEmoticonPackage {
    
    /**
     Give emoticon's name, return emoticon's image
     
     - parameter name: emoticon's name, including `[` and `]`. eg: [最右]
     
     - returns: image
     */
    public class func emoticonForName(name: String) -> UIImage? {
        var image: UIImage?
        if let fileName = sinaMap[name] {
            image = UIImage(contentsOfFile: "\(emoticonBundlePath)/\(EmoticonPackageType.Defalut.rawValue)/\(fileName)")
        } else if let fileName = lxhMap[name] {
            image = UIImage(contentsOfFile: "\(emoticonBundlePath)/\(EmoticonPackageType.Lxh.rawValue)/\(fileName)")
        }
        return image
    }
}