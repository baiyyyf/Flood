//
//  YFTabBar.swift
//  Flood
//
//  Created by byyyf on 2/4/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

public protocol YFTabBarDelegate {
    func didSelectedIndex(index: Int)
    func didSelectedMidItem(index: Int)
}

public class YFTabBar: UIView {
    
    public var topLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.8, alpha: 1).CGColor
        layer.opaque = true
        return layer
    }()

    public var backContentView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))

    public var translucent = true {
        didSet {
            backContentView.effect = translucent ? UIBlurEffect(style: .ExtraLight) : nil
        }
    }
    
    /// Setting items will remove old items from bar and be layouted again
    /// Bar's items, item's userInteraction is false
    public var items: [YFBarItem]? {
        didSet {
            guard let items = items else { return }
            if items.count % 2 != 0 {
                centerIndex = items.count / 2
            }
            oldValue?.forEach { $0.removeFromSuperview() }
            items.forEach(backContentView.contentView.addSubview)
            layoutItems()
        }
    }
    
    public lazy var indicator: UIView? = {
        if (!self.showIndicator) { return nil }
        let view = UIView()
        view.frame.size.height = 3
        view.backgroundColor = self.tintColor
        self.addSubview(view)
        return view
    }()
    
    public var showIndicator = false
    
    public var itemWidth: CGFloat = 1
    
    public var animationDuration: NSTimeInterval = 0.12
    
    public var selectedIndex = 0 {
        didSet {
            if centerIndex != selectedIndex {
                if selectedIndex >= centerIndex  {
                    delegate?.didSelectedIndex(selectedIndex-1)
                } else {
                    delegate?.didSelectedIndex(selectedIndex)
                }
                setIndicatorOffset(selectedIndex, animated: true)
                items?.forEach { $0.highlighted = false }
            }
            items?[selectedIndex].highlighted = true
        }
    }
    
    public var delegate: YFTabBarDelegate?
    
    private var centerIndex: Int?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backContentView)
        backContentView.contentView.layer.addSublayer(topLine)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        backContentView.frame = bounds
        topLine.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5)
        layoutItems()
    }
    
    override public func tintColorDidChange() {
        indicator?.backgroundColor = tintColor
    }
    
    private func layoutItems() {
        guard let items = items else { return }
        itemWidth = frame.width / CGFloat(items.count)
        
        let itemSize = CGSize(width: itemWidth, height: bounds.height)
        
        for i in 0..<items.count {
            let rect = CGRect(origin: CGPoint(x: CGFloat(i) * itemWidth, y: 0), size: itemSize)
            items[i].frame = rect
        }
        if let indicator = indicator {
            indicator.frame.origin.y = bounds.height - indicator.frame.height
            setIndicatorOffset(selectedIndex, animated: false)
        }
        items[selectedIndex].highlighted = true
    }
    
    
    private func setIndicatorOffset(targetIndex: Int, animated: Bool) {
        guard let items = items , indicator = indicator else { return }
        let targetX = items[targetIndex].center.x
        let duration = animated ? animationDuration * Double(fabs(indicator.center.x - targetX) / itemWidth) : 0
        UIView.animateWithDuration(duration) {
            indicator.center.x = targetX
            indicator.frame.size.width = items[self.selectedIndex].prefferdWidth
        }
    }

    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let x = Int(touches.first!.locationInView(self).x / itemWidth)
        if let centerIndex = centerIndex where centerIndex == x {
            delegate?.didSelectedMidItem(x)
            items?[centerIndex].highlighted = false
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let x = touches.first!.locationInView(self).x
        selectedIndex = Int(x / itemWidth)
    }

}
