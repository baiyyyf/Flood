//
//  Int+ToString.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

extension Int {
    var wb_toString: String {
        if self > 10000 {
            return "\(self/1000)k"
        }
        return "\(self)"
    }
}