//
//  FDError.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

struct FDError {
    static let Domain = "com.baiyyyf.Flood"
    enum Code: Int {
        case NetworingError = -1
        case NoMoreData     = -2
    }
    
    static func errorWithCode(code: Code, failureReason: String) -> NSError {
        return errorWithCode(code.rawValue, failureReason: failureReason)
    }
    
    static func errorWithCode(code: Int, failureReason: String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        return NSError(domain: Domain, code: code, userInfo: userInfo)
    }
}

extension NSError {
    var failureReason: String? {
        return userInfo[NSLocalizedFailureReasonErrorKey] as? String
    }
}