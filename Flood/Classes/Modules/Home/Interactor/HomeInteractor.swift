//
//  HomeInteractor.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation

class HomeInteractor: NSObject, HomeInteractorInput {
    var output: HomeInteractorOutput?
    var dataManager: WBDataManager<WBStatusline>?

    func requestData(sinceId: Int = 0, maxId: Int = 0) {
        dataManager?.fetchData(sinceId, maxId: maxId) { [weak self] result in
            if result.value?.statuses.count == 0 {
                let error = FDError.errorWithCode(.NoMoreData, failureReason: "No more data")
                self?.output?.receviedData(.Failure(error))
                return
            }
            self?.output?.receviedData(result)
        }
    }
}