//
//  HomePresenter.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Alamofire

class HomePresenter: NSObject {
    var homeInteractor: HomeInteractorInput?
    var userInterface: HomeViewInterface?
}

extension HomePresenter: HomeInteractorOutput {
    func receviedData(data: Result<WBStatusline, NSError>) {
        if let newStatusline = data.value {
            WBURLWrapper.sharedManager.startTask { ok in
                let statuses = self.statusDisplayDatasWithStatuses(newStatusline.statuses)
                self.userInterface?.updateWithData(statuses)
            }
        } else if let failureReason = data.error?.failureReason {
            self.userInterface?.showMessage(failureReason)
        }
    }
    
    func statusDisplayDatasWithStatuses(statuses: [WBStatus]) -> [WBStatusDisplayData] {
        return statuses.map {
            let data = WBStatusDisplayData(status: $0)
            StatusCell.cellHeight(data)
            return data
        }
    }
}

extension HomePresenter: HomeModuleInterface {
    func refresh(sinceId: Int, maxId: Int) {
        homeInteractor?.requestData(sinceId, maxId: maxId)
    }
}