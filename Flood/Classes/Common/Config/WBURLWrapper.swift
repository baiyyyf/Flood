//
//  WBURLWrapper.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

import Alamofire

class WBURLWrapper: NSObject {
    static let sharedManager = WBURLWrapper()
    var shortUrls: [String] = []
    var completion: ((Bool) -> Void)?
    
    let netManager: Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 3
        return Manager(configuration: configuration)
    }()
    
    var count: Int = 0 {
        didSet {
            if (count == 0) {
                completion?(isOk)
                isOk = true
            }
        }
    }
    
    var isOk = true
    
    let taskQueue = dispatch_queue_create("com.byyyf.urlConvert", DISPATCH_QUEUE_SERIAL)
    
    func startTask(completion: ((Bool) -> Void)?) {
        self.completion = completion
        let count = shortUrls.count
        let group = count / 20 + (count % 20 == 0 ? 0 : 1)
        self.count = group
        for index in 0..<group {
            let targetEnd = (index+1)*20
            let end = targetEnd > count ? count : targetEnd
            let data = Array(shortUrls[index*20..<end])
            var url = "https://api.weibo.com/2/short_url/expand.json?access_token=2.002_TFFDfj3PXC2dee38c82bH1azBC"
            data.forEach {
                url.appendContentsOf("&url_short=\($0)")
            }
            startSingleTask(url)
        }
    }
    
    func startSingleTask(url: String) {
        netManager.request(.GET, url)
            .responseJSON { box in
                if let value = box.result.value, urls = value["urls"] as? NSArray {
                    urls.forEach { item in
                        if let
                            urlShort = item["url_short"] as? String,
                            urlLong = item["url_long"] as? String,
                            success = item["result"] as? Bool
                            where success
                        {
                            URLDict[urlShort] = urlLong
                        }
                    }
                    
                } else {
                    self.isOk = false
                }
                dispatch_sync(self.taskQueue) {
                    --self.count
                }
        }
    }
    
}

extension String {
    func bf_replaceURL() {
        let str = NSString(string: self)
        let ranges = urlRegex.matchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, str.length))
            .map { $0.rangeAtIndex(0) }
        let urls: [String] = ranges.map {
            str.substringWithRange($0)
        }
        WBURLWrapper.sharedManager.shortUrls.appendContentsOf(urls)
    }
}

private let urlRegex = try! NSRegularExpression(pattern: "(http|https)://[a-zA-Z0-9/\\.]*", options: NSRegularExpressionOptions())