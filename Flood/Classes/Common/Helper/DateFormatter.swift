//
//  DateFormatter.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

let dateFormater: NSDateFormatter = {
    let df = NSDateFormatter()
    df.locale = NSLocale(localeIdentifier: "en_US")
    df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
    return df
}()

let shortDateFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.locale = NSLocale(localeIdentifier: "zh_CN")
    df.dateFormat = "MMMdd HH:mm"
    return df
}()

let hourFormater: NSDateFormatter = {
    let df = NSDateFormatter()
    df.locale = NSLocale(localeIdentifier: "en_US")
    df.dateFormat = "HH:mm"
    return df
}()