//
//  FDSuspendController.swift
//  Flood
//
//  Created by byyyf on 3/4/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import SnapKit

class FDSuspendController: UIViewController {
    
    private var KVOContext = "PullToRefreshKVOContext"
    private let contentOffsetKeyPath = "contentOffset"
    
    var headerView = UIView()
    var suspendBar = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    var segementControl = UISegmentedControl()
    let suspendBarBottomLine = UIView()
    
    //
    var tableViewOffsets: [CGFloat] = []
    var viewControllers: [UITableViewController]? {
        didSet {
            if let vcs = viewControllers {
                tableViewOffsets = Array(count: vcs.count, repeatedValue: 0)
                segementControl = UISegmentedControl(items: vcs.flatMap { $0.title })
            }
        }
    }
    var scrollView: UIScrollView? {
        didSet {
            oldValue?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &KVOContext)
            scrollView?.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .New, context: &KVOContext)
        }
    }
    
    var containerView = UIView()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.hidden = true
        segementControl.selectedSegmentIndex = 0
        segementControl.tintColor = UIColor(hex: 0x9B9B9B)
        view.addSubview(containerView)
        headerView.frame.size.height = 160
        view.addSubview(headerView)
        view.addSubview(suspendBar)
        suspendBar.contentView.addSubview(suspendBarBottomLine)
        suspendBar.contentView.addSubview(segementControl)
        layoutPageViews()
        
        segementControl.addTarget(self, action: "selectedAtIndex:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        moveToViewControllerAtIndex(selectedIndex)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func layoutPageViews() {
        containerView.snp_makeConstraints { make in
            make.edges.equalTo(view)
        }
        headerView.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(headerView.frame.height)
            make.top.equalTo(view)
        }
        suspendBar.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(44)
            make.top.equalTo(headerView.snp_bottom)
        }
        suspendBarBottomLine.snp_makeConstraints { make in
            make.left.right.equalTo(suspendBar)
            make.height.equalTo(0.5)
            make.top.equalTo(suspendBar.snp_bottom)
        }
        segementControl.snp_makeConstraints { make in
            make.left.equalTo(suspendBar).offset(12)
            make.right.equalTo(suspendBar).offset(-12)
            make.centerY.equalTo(suspendBar)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if let scrollView = object as? UIScrollView where context == &KVOContext && keyPath == contentOffsetKeyPath && scrollView == self.scrollView {
            scrollViewDidScroll(scrollView)
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = -scrollView.bf_contentOffset
        navigationController?.navigationBar.hidden = y >= 0
        if y < 64 - headerView.frame.height {
            navigationController?.navigationBar.alpha = 1
            headerView.snp_updateConstraints { make in
                make.top.equalTo(view).offset(64 - headerView.frame.height)
            }
        } else if y > 0 {
            headerView.snp_updateConstraints { make in
                make.top.equalTo(view).offset(0)
            }
        } else {
            navigationController?.navigationBar.alpha = fabs(y) / (headerView.frame.height - 64)
            headerView.snp_updateConstraints { make in
                make.top.equalTo(view).offset(y)
            }
        }
    }
    
    func moveToViewControllerAtIndex(index: Int) {
        guard let viewControllers = viewControllers else { return }
        let toVC = viewControllers[index]
        toVC.tableView.contentInset.top = headerView.frame.height + 24
        
        if childViewControllers.count == 0 {
            addChildViewController(toVC)
            containerView.addSubview(toVC.view)
            toVC.didMoveToParentViewController(self)
        } else {
            let fromVC = viewControllers[selectedIndex]
            if (fromVC === toVC) { return }
            
            /**/
            tableViewOffsets[selectedIndex] = fromVC.tableView.bf_contentOffset - -headerView.frame.minY
            if toVC.isViewLoaded() {
                if headerView.frame.minY == 0 {
                    toVC.tableView.bf_contentOffset = 0
                } else {
                    toVC.tableView.bf_contentOffset = tableViewOffsets[index] - headerView.frame.minY
                }
                
            } else {
                toVC.tableView.bf_contentOffset = -headerView.frame.minY
            }
            
            addChildViewController(toVC)
            containerView.addSubview(toVC.view)
            toVC.didMoveToParentViewController(self)
            fromVC.willMoveToParentViewController(nil)
            fromVC.removeFromParentViewController()
            fromVC.view.removeFromSuperview()
        }
        scrollView = toVC.tableView
    }
    
    func selectedAtIndex(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        moveToViewControllerAtIndex(index)
        selectedIndex = index
    }
}


extension UIScrollView {
    var bf_contentOffset: CGFloat {
        get {
            return contentOffset.y + contentInset.top
        }
        set {
            contentOffset.y = newValue - contentInset.top
        }
    }
}

