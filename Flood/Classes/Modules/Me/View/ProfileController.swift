//
//  ProfileController.swift
//  Flood
//
//  Created by byyyf on 3/4/16.
//  Copyright © 2016 byyyf. All rights reserved.
//
import UIKit
import Alamofire

class ProfileController: FDSuspendController {
    var profireWireframe = HomeWireFrame()

    var profileView: FDProfileView {
        return headerView as! FDProfileView
    }
    
    override func loadView() {
        super.loadView()
        profireWireframe.homePresenter = HomePresenter()
        let profireDataManger = WBDataManager<WBStatusline>(requestURL: WeiboURL.UserTimeline)
        let meVC = profireWireframe.configuredHomeViewController(profireDataManger)
        meVC.title = "微博"
        
        viewControllers = [BFTableViewController(title: "主页"), meVC, BFTableViewController(title: "相册")]
        headerView  = NSBundle.mainBundle().loadNibNamed("FDProfileView", owner: self, options: nil)[0] as! FDProfileView
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        Alamofire.request(.GET, UserURL.UserInfo, parameters: ["access_token": "2.002_TFFDfj3PXC2dee38c82bH1azBC", "screen_name": "byyyf"])
            .responseJSON { response in
                if let user = response.result.map(WBUser.objectFromJSON).value {
                    self.profileView.setData(user)
                }
                
        }
    }
}
