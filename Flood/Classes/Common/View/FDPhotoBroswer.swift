//
//  FDPhotoBroswer.swift
//  Flood
//
//  Created by byyyf on 2/6/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import YYWebImage

let identifier = "com.baiyyyf.FDPhotoCell"

public class FDPhotoBroswer: UIViewController {
    
    /// A full screen colloction view for displaying photos.
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.view.bounds.size
        layout.scrollDirection = .Horizontal
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.registerClass(FDPhotoCell.self, forCellWithReuseIdentifier: identifier)
        view.dataSource = self
        view.delegate = self
        view.pagingEnabled = true
        return view
    }()
    
    public weak var currentCell: FDPhotoCell? {
        return collectionView.visibleCells().first as? FDPhotoCell
    }
    
    let images = [UIImage(named: "0"), UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4")]

    //MARK: - Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // set collectionView item size of the layout after device rotated.
        collectionView.frame = view.bounds
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.bounds.size
        collectionView.collectionViewLayout = layout
    }

}

extension FDPhotoBroswer: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! FDPhotoCell
        cell.setImage(images[indexPath.item]!)
        return cell
    }
}

extension FDPhotoBroswer: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? FDPhotoCell {
            cell.scrollView.setZoomScale(1, animated: false)
        }
    }
}

public class FDPhotoCell: UICollectionViewCell {
    
    public lazy var imageView: YYAnimatedImageView = {
        let view = YYAnimatedImageView(frame: self.bounds)
        view.contentMode = .ScaleAspectFit
        return view
    }()
    
    public lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: self.bounds)
        view.decelerationRate = 0
        view.maximumZoomScale = 2
        view.delegate = self
        return view
    }()
    
    private lazy var containerView: UIView = UIView(frame: self.bounds)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame.size = bounds.size
        containerView.frame = bounds
        scrollView.frame = bounds
    }
    
    private func setImage(image: UIImage) {
        let size = image.size
        let imageScale = size.width/size.height
        let cellScale = bounds.width/bounds.height
//        print(imageScale)
//        print(cellScale)
//        print(bounds.width / imageScale)
        

        let fittedSize = CGSize(width: bounds.width, height: bounds.width / imageScale)
        imageView.frame.size = fittedSize
        if (imageScale < cellScale) {
            imageView.frame.origin = CGPoint.zero
            scrollView.contentSize = fittedSize
            
        } else {
            imageView.center = containerView.center
            scrollView.contentSize = CGSize.zero
            
            print("------------Center----------------")
        }
        
        
        
        
        print(scrollView.contentSize)
        
        
        imageView.image = image
    }
    
    public func setImageWithURL(url: NSURL, placeholder: UIImage?) {
        imageView.yy_setImageWithURL(url, placeholder: placeholder, options: YYWebImageOptions.ProgressiveBlur.union(.AvoidSetImage),
            progress: { (receivedSize, expectedSize) -> Void in
            
            }, transform: nil) { [weak self] (image, _, _, state, _) -> Void in
                if (state != .Finished) { return }
                self?.setImage(image)
        }
    }
}

extension FDPhotoCell: UIScrollViewDelegate {
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}