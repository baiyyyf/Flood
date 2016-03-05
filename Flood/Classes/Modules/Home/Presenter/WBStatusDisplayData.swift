//
//  WBStatusDisplayData.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class WBStatusDisplayData {
    var createdDate: NSDate?
    var id: Int
    var attributedText: NSAttributedString
    var repostsCount: String
    var commentsCount: String
    var attitudesCount: String
    var photos: [WBPhotoDisplayData]?
    var user: WBUserLiteDisplayData?
    var retweetStatus: WBStatusDisplayData?
    
    var cellHeight: CGFloat = 0
    var textHeight: CGFloat = 0
    var mediaHeight: CGFloat!
    
    init(status: WBStatus) {
        createdDate = dateFormater.dateFromString(status.createdAt)
        attributedText = NSAttributedString(string: status.text)
        id = status.id
        repostsCount = status.repostsCount.wb_toString
        commentsCount = status.commentsCount.wb_toString
        attitudesCount = status.attitudesCount.wb_toString
        let bmiddle = status.bmiddlePic
        let origin = status.originalPic
        photos = status.pictureURLs?.map {
            return WBPhotoDisplayData(photoURL: $0, bmiddle: bmiddle, origin: origin)
        }
        if let user = status.user {
            self.user = WBUserLiteDisplayData(user: user)
        }
        if let retweetStatus = status.retweetStatus {
            self.retweetStatus = WBStatusDisplayData(status: retweetStatus)
        }
    }
}

protocol SinceTimeStringConvertable {
    var createdDate: NSDate? { get }
    var sinceTime: String { get }
}

extension SinceTimeStringConvertable {
    var sinceTime: String {
        guard let date =  createdDate else { return "" }
        let time = Int(-date.timeIntervalSinceNow / 60)
        let calendar = NSCalendar.currentCalendar()
        
        if (calendar.isDateInToday(date)) {
            switch time {
            case 0..<1:
                return "刚刚"
            case 1..<60:
                return "\(time)分钟前"
            case 60..<3600:
                return "\(time/60)小时前"
            default:
                return ""
            }
        } else if (calendar.isDateInYesterday(date)) {
            return "昨天 \(hourFormater.stringFromDate(date))"
        } else {
            return shortDateFormatter.stringFromDate(date)
        }
    }
    
    var attributedSinceTime: NSAttributedString {
        return NSAttributedString(string: sinceTime, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor(white: 0.6, alpha: 1)])
    }
}

extension WBStatusDisplayData: SinceTimeStringConvertable {}