//
//  SearchPresenter.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class SearchPresenter: NSObject, SearchInteractorOutput {
    var searchInteractor: SearchInteractor?
    var userInterface: SearchViewInterface?
    var searchWireframe: SearchWireFrame?
    
    func receivedHotWords(items: [WBHotWord]) {
        userInterface?.showHotWordItems(items)
    }
}

extension SearchPresenter: SearchMoudleInterface {
    func updateHotWords() {
        searchInteractor?.fetchHotWords()
    }
    
    func dismissSearch() {
        searchWireframe?.dismiss()
    }
}
