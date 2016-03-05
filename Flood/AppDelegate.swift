//
//  AppDelegate.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let homePresenter = HomePresenter()
        let homeDataManger = WBDataManager<WBStatusline>(requestURL: WeiboURL.FriendsTimeline)
        let homeInteractor = HomeInteractor()
        
        homePresenter.homeInteractor = homeInteractor
        
        homeInteractor.dataManager = homeDataManger
        homeInteractor.output = homePresenter
        
        let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FDTabBarController") as! FDTabBarController
        if let navVC = tabVC.viewControllers?.first as? FDNavigationController, homeVC = navVC.viewControllers.first as? HomeViewController {
            homeVC.eventHandler = homePresenter
            homePresenter.userInterface = homeVC
        }
        window?.rootViewController = tabVC
        return true
    }

   }

