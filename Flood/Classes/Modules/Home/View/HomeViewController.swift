//
//  HomeViewController.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import BFLabel
import MJRefresh

class HomeViewController: UITableViewController {

    let homeCellReuseID = "homeCellReuseID\(arc4random())"
    var models: [WBStatusDisplayData] = []
    
    var eventHandler: HomeModuleInterface?
    
    //var refreshControler = UIRefreshControl()
    
    lazy var refreshControler: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "byyyf"
        refreshControler.automaticallyChangeAlpha = true
        refreshControler.lastUpdatedTimeLabel?.hidden = true
        tableView.registerClass(StatusCell.self, forCellReuseIdentifier: homeCellReuseID)
        tableView.addSubview(refreshControler)
        eventHandler?.refresh(0, maxId: 0)
        
        //refreshControler.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
    }
    
    func refresh() {
        eventHandler?.refresh(0, maxId: 0)
    }

}

extension HomeViewController: HomeViewInterface {
    func showMessage(message: String) {
        print(message)
    }
    
    func updateWithData(data: [WBStatusDisplayData]) {
        models = data
        tableView.reloadData()
        refreshControler.endRefreshing()
    }
}

import SafariServices

extension UIViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension HomeViewController: StatusCellDelgate {
    func touchedImage(index: Int, imageViews: [UIImageView], photos: [WBPhotoDisplayData]) {
        let vc = UNPhotoBrowser()
        vc.dataSource = WBPhotos(photos: photos)
        vc.fromIndex = index
        vc.transitioningDelegate = self
        vc.fromImageViews = imageViews
        presentViewController(vc, animated: true, completion: nil)
    }

    func touchedMetion(label: BFLabel, metion: String) {
        
    }
    
    func touchedTag(label: BFLabel, tag: String) {
        
    }
    
    func touchedURL(label: BFLabel, url: String) {
        if let url = NSURL(string: url) {
            let safariVC = SFSafariViewController(URL: url)
            safariVC.delegate = self
            safariVC.view.tintColor = FDConfig.customConfig.tintColor
            presentViewController(safariVC, animated: true, completion: nil)
        }
    }
    
    func touchedLabel(label: BFLabel) {

    }
    
    func longPressedMetion(label: BFLabel, metion: String) {
        copyStringToPasteboard(metion)
    }
    
    func longPressedTag(label: BFLabel, tag: String) {
        copyStringToPasteboard(tag)
    }
    
    func longPressedURL(label: BFLabel, url: String) {
        copyStringToPasteboard(url)
    }
    
    func copyStringToPasteboard(text: String) {
        UIPasteboard.generalPasteboard().string = text
    }
    
}

class WBPhotos: NSObject {
    var photos: [WBPhotoDisplayData]
    
    init(photos: [WBPhotoDisplayData]) {
        self.photos = photos
    }
    
}

extension WBPhotos: UNPhotos {
    var originalURLs: [NSURL] {
        return photos.map { $0.originalURL! }
    }
    
    var count: Int {
        return photos.count
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UNPhotoPushTransion()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return  UNPhotoPopTransion()
    }
}