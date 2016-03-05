//
//  HomeInteractorIO.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeInteractorInput {
    func requestData(sinceId: Int, maxId: Int)
}

protocol HomeInteractorOutput {
    func receviedData(data: Result<WBStatusline, NSError>)
}