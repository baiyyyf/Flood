//
//  FDConfig.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

import UIKit

/************************ Const ************************/

// Device
let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
let screenWidth = UIScreen.mainScreen().bounds.width

// System
let unitFontHeight: CGFloat = 1.193
//let unitFontDesender: CGFloat = -0.241


// Flood
let horMargin: CGFloat = 14
let verMargin: CGFloat = 12

struct FDConfig {
    
    static let cellBackgroundColor = UIColor(white: 0.985, alpha: 1)
    static let nightModeCellBackgroundColor = UIColor(hex: 0x444444)
    static var contentWidth: CGFloat {
        return screenWidth - horMargin*2
    }
    
    static let customConfig = FDCustomConfig.configure("FDCustomConfig")
}

struct HomeConfig {
    static let avatarTopMargin: CGFloat     = 18
    static let avatarHeight: CGFloat        = 36
    static let imageMargin: CGFloat         = 4
    static let footerHeight: CGFloat        = 34
    static let cellSpacing: CGFloat         = 14
    static let headerHeight                 = avatarTopMargin + avatarHeight + verMargin
    static let fixedHeight                  = headerHeight + footerHeight + cellSpacing
    static let smallPictureHeight           = ceil((FDConfig.contentWidth - imageMargin*2) / 3)
    static let largePictureHeight: CGFloat  = 200
    static let avatarSize                   = CGSize(width: avatarHeight, height: avatarHeight)
    static let smallPictureSize             = CGSize(width: smallPictureHeight, height: smallPictureHeight)
}

