//
//  Alamofire+Monad.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.Result {
    func map<U>(f: Value -> U) -> Result<U, Error> {
        switch self {
        case .Success(let t): return .Success(f(t))
        case .Failure(let err): return .Failure(err)
        }
    }
    func flatMap<U>(f: Value -> Result<U, Error>) -> Result<U, Error> {
        switch self {
        case .Success(let t): return f(t)
        case .Failure(let err): return .Failure(err)
        }
    }
}