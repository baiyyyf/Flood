//
//  YFBarItem.swift
//  Flood
//
//  Created by byyyf on 2/4/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

public protocol YFBarItemHighlightable {
    var highlighted: Bool { get set }
}

public class YFBarItem: UIView, YFBarItemHighlightable {

    public var textLabel: UILabel?
    
    public var imageView: UIImageView?

    public var insets = UIEdgeInsetsZero
    
    public var imageRenderMode = UIImageRenderingMode.AlwaysTemplate
    
    public var prefferdWidth: CGFloat {
        if let textLabel = textLabel {
            return textLabel.sizeThatFits(textLabel.frame.size).width + 2
        }
        return imageView?.frame.width ?? bounds.width
    }
    
    public var highlighted = false {
        didSet {
            textLabel?.highlighted = highlighted
            imageView?.highlighted = highlighted
        }
    }
    
    public init(text: String? = nil) {
        super.init(frame: CGRect.zero)
        
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.font = UIFont.systemFontOfSize(13)
        label.highlightedTextColor = tintColor
        addSubview(label)
        textLabel = label
    }
    
    public init(image: UIImage? = nil, highlightedImage: UIImage? = nil, imageRenderMode: UIImageRenderingMode = .AlwaysTemplate, insets: UIEdgeInsets = UIEdgeInsetsZero) {
        super.init(frame: CGRect.zero)
        self.imageRenderMode = imageRenderMode
        self.insets = insets
        let imageView = UIImageView()
        imageView.contentMode = .Center
        imageView.tintColor = tintColor
        imageView.image = image
        if let highlightedImage = highlightedImage {
            imageView.highlightedImage = highlightedImage
        } else {
            imageView.highlightedImage = image?.imageWithRenderingMode(imageRenderMode)
        }
        addSubview(imageView)
        self.imageView = imageView
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        let frame = UIEdgeInsetsInsetRect(bounds, insets)
        textLabel?.frame = frame
        imageView?.frame = frame
    }
    
    override public func tintColorDidChange() {
        textLabel?.tintColor = tintColor
        
        if let imageView = imageView where imageRenderMode == .AlwaysTemplate {
            imageView.tintColor = tintColor
            imageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        }
        
    }
    
    public class func textItems(texts: [String]) -> [YFBarItem] {
        return texts.map(YFBarItem.init)
    }
    
    public class func imageItems(images: [UIImage?], highlightedImages: [UIImage?], insets: UIEdgeInsets) -> [YFBarItem] {
        var items: [YFBarItem] = []
        for (index, image) in images.enumerate() {
            let item = YFBarItem(image: image, highlightedImage: highlightedImages[index],insets: insets)
            items.append(item)
        }
        return items
    }
}


