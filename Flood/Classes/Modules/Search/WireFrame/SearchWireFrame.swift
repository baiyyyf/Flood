//
//  SearchWireFrame.swift
//  Flood
//
//  Created by byyyf on 3/3/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

class SearchWireFrame: NSObject {
    var searchPresenter: SearchPresenter?
    weak var searchViewController: SearchViewController?
    
    func presentSearchInterfaceFromViewController(viewController: UIViewController) {
        let newViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        let searchInteractor = SearchInteractor()
        searchInteractor.output = searchPresenter
        
        newViewController.eventHandler = searchPresenter
        
        searchPresenter?.searchWireframe = self
        searchPresenter?.searchInteractor = searchInteractor
        searchPresenter?.userInterface = newViewController
        
        searchViewController = newViewController
        
        newViewController.modalPresentationStyle = .OverCurrentContext
        viewController.presentViewController(newViewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        searchViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
