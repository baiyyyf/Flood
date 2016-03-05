//
//  SearchInteractor.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Alamofire
import Maker

class SearchInteractor: NSObject, SearchInteractorInput {
    var output: SearchInteractorOutput?
    
    func fetchHotWords() {
        Alamofire.request(.GET, "http://m.weibo.cn/page/pageJson?containerid=100103type=25")
            .responseJSON { response in
                if let cardGroup = response.result.value?["cards"].arrayValue[1]["card_group"].array
                    where cardGroup.count > 0
                {
                    var items: [WBHotWord] = []
                    for (index, item) in cardGroup.enumerate() {
                        let model = WBHotWord.objectFromJSON(item)
                        model.index = index + 1
                        items.append(model)
                    }
                    self.output?.receivedHotWords(items)
                }
        }
    }
}
