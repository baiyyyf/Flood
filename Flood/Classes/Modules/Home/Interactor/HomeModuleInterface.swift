//
//  HomeModuleInterface.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

protocol HomeModuleInterface {
    func refresh(sinceId: Int, maxId: Int)
}