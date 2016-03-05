//
//  UNPhotoCell.swift
//  TransitionDemo
//
//  Created by White on 15/11/6.
//  Copyright © 2015年 White. All rights reserved.
//

import UIKit
import YYWebImage

public class UNPhotoCell: UICollectionViewCell {
    
    /**
    The container of the image view,
    */
    lazy public var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 2
        scrollView.decelerationRate = 0
        scrollView.delegate = self
        
        return scrollView
    }()
    
    /**
     Set the image and the imageView will resized to fit the container bounds.
     */
    lazy public var imageView: YYAnimatedImageView = {
       let imageView = YYAnimatedImageView()
        imageView.contentMode = .ScaleAspectFit
        
        return imageView
    }()
    /**
     Tips:
     The stand for resizing imageView is container's width.
     For example:
     (i = image, c = container, W, H = width, height)
     iW/iH --- cW/cH
     -> imageView's width = cW, imageView's height = cW/(iW/iH)
     */
    
    // MARK: - Life Cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    private func prepare() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
     
    // MARK: - Method

    public func saveImageToAlbum() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            return
        }
    }
}

extension UNPhotoCell: UIScrollViewDelegate {
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}