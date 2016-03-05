//
//  WBUserDisplayData.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class WBUserLiteDisplayData {
    var id: Int
    var attributedName: NSAttributedString
    var lAvatarURL: NSURL
    
    init(user: WBUserLite) {
        id = user.id
        lAvatarURL = NSURL(string: user.lAvatarURL)!
        var attributedName: NSMutableAttributedString
        let attributes = [NSForegroundColorAttributeName: FDConfig.customConfig.tintColor,
            NSFontAttributeName: FDConfig.customConfig.avatarTextFont]
        switch user.verifiedType {
        case 0: // Vip
            attributedName = NSMutableAttributedString(string: "\(user.screenName) V", attributes: attributes)
            attributedName.addAttribute(NSForegroundColorAttributeName,
                value: UIColor(red:0.359, green:0.673, blue:0.919, alpha:1),
                range: NSMakeRange(attributedName.length - 1, 1))
        case 1, 2, 3, 5: // EnterpriseVip
            attributedName = NSMutableAttributedString(string: "\(user.screenName) V", attributes: attributes)
            attributedName.addAttribute(NSForegroundColorAttributeName,
                value: UIColor(red:0.976, green:0.761, blue:0.063, alpha:1),
                range: NSMakeRange(attributedName.length - 1, 1))
        case 220: // Grassroot
            attributedName = NSMutableAttributedString(string: "\(user.screenName) ★", attributes: attributes)
            attributedName.addAttribute(NSForegroundColorAttributeName,
                value: UIColor(red:0.914, green:0.294, blue:0.183, alpha:1),
                range: NSMakeRange(attributedName.length - 1, 1))
        default:
            attributedName = NSMutableAttributedString(string: "\(user.screenName)", attributes: attributes)
        }
        self.attributedName = attributedName
    }
}
