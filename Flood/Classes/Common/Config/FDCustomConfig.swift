//
//  FDCustomConfig.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Maker

let fontWeight = UIFontWeightLight

class FDCustomConfig: Maker {
    /* 正文字体 */
    
    var bodyFontSize: CGFloat = 16 {
        didSet {
            bodyTextFont = UIFont.systemFontOfSize(bodyFontSize, weight: fontWeight)
            subFontSize = bodyFontSize - 3
            avatarTextFont = UIFont.systemFontOfSize(bodyFontSize - 1, weight: fontWeight)
        }
    }
    var bodyTextFont = UIFont.systemFontOfSize(16, weight: fontWeight)
    var bodyTextColor = UIColor(white: 0.1, alpha: 1)
    
    var avatarTextFont = UIFont.systemFontOfSize(15, weight: fontWeight)
    
    /* 底栏、时间字体 */
    var subFontSize: CGFloat = 13 {
        didSet {
            subTextFont = UIFont.systemFontOfSize(subFontSize, weight: fontWeight)
        }
    }
    var subTextFont = UIFont.systemFontOfSize(13, weight: fontWeight)
    var subTextColor = UIColor(white: 0.2, alpha: 1)
    
    var lineSpacing: CGFloat = 4
    
    var tintColor = UIColor(hex: 0x019DF2)
    
    var loadCommentAvatarImage = true
    
    var refreshCount = 100
    
    var loadWeiboPicture = true
    
    static let defaultConfig = FDCustomConfig()
    
    class func configure(name: String) -> FDCustomConfig {
        return FDCustomConfig.read(name) ?? FDCustomConfig()
    }
    
    class func read(name: String) -> FDCustomConfig? {
        return FDCustomConfig.read(name: name) as? FDCustomConfig
    }
}

extension FDCustomConfig {
    func save() {
        writeToFile(name: "FDCustomConfig")
    }
}