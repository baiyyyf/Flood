//
//  FDImageView.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

public class FDImageView: UIImageView {
    
    public var scale: CGFloat {
        return frame.width / frame.height
    }
    
    public var preferredSize: CGSize?
    
    override public var image: UIImage? {
        willSet{
            if let preferredSize = preferredSize,  image = newValue {
                layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                let imageScale = image.size.scale
                let containerScale = preferredSize.scale
                var width: CGFloat
                switch imageScale {
                    // 比例较为接近正方形，固定高，宽度自适应
                case 0.6...containerScale:
                    width = preferredSize.height * imageScale
                    // 长图，固定宽，取容器宽0.6倍，只显示顶部
                case 0..<0.6:
                    width = preferredSize.width * 0.5
                    frame.size.width = width
                    let suitableImageHeight = width / imageScale
                    layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: preferredSize.height / suitableImageHeight)
                default:
                    width = preferredSize.width
                    break
                }
                frame.size = CGSize(width: width, height: preferredSize.height)
            }
            
        }
    }
}

extension CGSize {
    var scale: CGFloat {
        return width/height
    }
}
