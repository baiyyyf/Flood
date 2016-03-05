//
//  SearchViewController.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var hotWords: [WBHotWord] = []
    var eventHandler: SearchMoudleInterface?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let searchOptionButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        view.setTitle("微博", forState: .Normal)
        view.setTitleColor(UIColor(white: 0.6, alpha: 1), forState: .Normal)
        view.titleLabel?.font = UIFont.systemFontOfSize(14)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        if let eventHandler = eventHandler {
            eventHandler.updateHotWords()
            refreshControl.beginRefreshing()
            refreshControl.addTarget(eventHandler as? AnyObject, action: "updateHotWords", forControlEvents: .ValueChanged)
        }
        textFeild.leftView = searchOptionButton
        textFeild.leftViewMode = .Always
    }

    @IBAction func dismiss() {
        eventHandler?.dismissSearch()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension SearchViewController: SearchViewInterface {
    func showHotWordItems(items: [WBHotWord]) {
        hotWords = items
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WBHotWordCell", forIndexPath: indexPath) as! WBHotWordCell
        cell.setData(hotWords[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotWords.count
    }
}

