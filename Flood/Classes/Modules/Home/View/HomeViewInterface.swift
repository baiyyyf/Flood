//
//  HomeViewInterface.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

protocol HomeViewInterface {
    func showMessage(message: String)
    func updateWithData(data: [WBStatusDisplayData])
}