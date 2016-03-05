//
//  SearchInteractorIO.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
    func fetchHotWords()
}

protocol SearchInteractorOutput {
    func receivedHotWords(items: [WBHotWord])
}