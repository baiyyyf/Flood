//
//  FDTextParser.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import BFLabel

var URLDict: [String: String] = [:]

class FDTextParser: BFTextParser {
    override func replaceURL(attr: NSMutableAttributedString) -> NSMutableAttributedString {
        let ranges = urlRegex.matchesInString(attr.string, options: NSMatchingOptions(), range: NSMakeRange(0, attr.length) )
            .map { $0.rangeAtIndex(0) }
        
        for range in ranges.reverse() {
            let URLAttr = attr.attributedSubstringFromRange(range)
            let shortUrl = URLAttr.string
            let url = URLDict[shortUrl] ?? shortUrl
            
            let attachment = BFStaticTextAttachment()
            attachment.image = imageForURL(url)
            let attrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            var attributes = URLAttr.attributesAtIndex(0, effectiveRange: nil)
            attributes[BFURLStringAttributeName] = url
            attributes[BFTextTypeAttributeName] = BFTextType.URL.rawValue
            attrM.addAttributes(attributes, range: NSRange(location: 0, length: attrM.length))
            attr.replaceCharactersInRange(range, withAttributedString: attrM)
        }
        return attr
    }
    
    func imageForURL(url: String) -> UIImage? {
        if let range = domainRegex.matchesInString(url, options: NSMatchingOptions(), range: NSMakeRange(0, url.characters.count))
            .first?.rangeAtIndex(0)
        {
            let start = url.startIndex.advancedBy(range.location)
            let end = url.startIndex.advancedBy(NSMaxRange(range))
            let range = start..<end
            let domain = url.substringWithRange(range)
            
            if let image = UIImage(named: domain) {
                return image
            }
        }
        return UIImage(named: "web")
    }
}

private let urlRegex = try! NSRegularExpression(pattern: "(http|https)://[a-zA-Z0-9/\\.]*", options: .DotMatchesLineSeparators)

private let domainRegex = try! NSRegularExpression(pattern: "[^\\./]*(?=\\.com)", options: NSRegularExpressionOptions())
