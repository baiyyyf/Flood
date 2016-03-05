//
//  FDTabBarController.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import SnapKit

class FDTabBarController: UITabBarController {

    let bar = YFTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.hidden = true
        addBar()
    }
    
    private func addBar() {
        bar.tintColor = UIColor(hex: 0x019DF2)
        bar.showIndicator = false
        bar.delegate = self
        bar.items = YFBarItem.imageItems([UIImage(named: "friendsline_home"), UIImage(named: "friendsline_comment"), UIImage(named: "flood_normal"), UIImage(named: "friendsline_list"), UIImage(named: "friendsline_person")], highlightedImages: [nil, nil, UIImage(named: "flood_highlighted"), nil, nil], insets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        view.addSubview(bar)
        bar.snp_makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(tabBar).offset(-4)
        }
    }
}

extension FDTabBarController: YFTabBarDelegate {
    func didSelectedMidItem(index: Int) {
        print(index)
        let searchWireframe = SearchWireFrame()
        searchWireframe.searchPresenter = SearchPresenter()
        searchWireframe.presentSearchInterfaceFromViewController(self)
    }
    
    func didSelectedIndex(index: Int) {
        selectedIndex = index
    }
}
