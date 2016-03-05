//
//  HomeWireFrame.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class HomeWireFrame: NSObject {
    var homePresenter: HomePresenter?

    func configureedProfileInterfaceWithDataManger(dataManger: WBDataManager<WBStatusline>) -> HomeViewController {
        let newViewController = homeViewControllerFromStoryboard()
        configureHomeViewControllerWithDataManger(newViewController, dataManger: dataManger)
        return newViewController
    }
    
    func configuredHomeViewController(dataManger: WBDataManager<WBStatusline>) -> HomeViewController {
        let vc = HomeViewController()
        configureHomeViewControllerWithDataManger(vc, dataManger: dataManger)
        return vc
    }
    
    func configureHomeViewControllerWithDataManger(vc: HomeViewController, dataManger: WBDataManager<WBStatusline>) {
        let homrInteractor = HomeInteractor()
        homrInteractor.dataManager = dataManger
        homrInteractor.output = homePresenter
        vc.eventHandler = homePresenter
        homePresenter?.homeInteractor = homrInteractor
        homePresenter?.userInterface = vc
    }
    
    func homeViewControllerFromStoryboard() -> HomeViewController {
        let viewController = mainStoryboard().instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        return viewController

    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
}