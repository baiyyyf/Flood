//
//  Dictionary+Merge.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) {
        for (k, v) in other {
            self[k] = v
        }
    }
}