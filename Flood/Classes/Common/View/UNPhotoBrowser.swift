//
//  UNPhotoBrowser.swift
//  TransitionDemo
//
//  Created by White on 15/11/6.
//  Copyright © 2015年 White. All rights reserved.
//

import UIKit
import YYWebImage

@objc
public protocol UNPhotos: NSObjectProtocol {
    
    optional var placeholderImages: [UIImage] { get }
    
    optional var bmiddleURLs: [NSURL] { get }
    
    var originalURLs: [NSURL] { get }
    
    var count: Int { get }
}

//public extension UNPhotos {
//    var count: Int {
//        return originalURLs.count
//    }
//}

public class UNPhotoBrowser: UIViewController {

    /**
     The photos container.
    */
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.frame.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsZero
        layout.scrollDirection = .Horizontal
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.registerClass(UNPhotoCell.self, forCellWithReuseIdentifier: UNPhotoBrowserId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /**
     
    */
    public lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(hex: 0x277AAC)
        pageControl.numberOfPages = self.dataSource!.count
        let size = pageControl.sizeForNumberOfPages(self.dataSource!.count)
        pageControl.frame = CGRectMake((self.view.frame.width - size.width) / 2, self.view.frame.height - size.height - 12, size.width, size.height)
        
        return pageControl
    }()

    /**
     Determine which photo to show at first when view appeared.
     Defafult is 0, which is the first of the photos.
    */
    public var fromIndex = 0
    
    /**
     The index of the displaying cell
     */
    public var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    /**
     Current displaying cell for photo
     Retained by colloction view
    */
    private weak var currentPhotoCell : UNPhotoCell? {
        return collectionView.visibleCells().first as? UNPhotoCell
    }
    
    /**
     provide image URLs
    */
    public var dataSource: UNPhotos?
    
    /**
     Perform the view controller transition
    */
    public var fromImageViews: [UIImageView]?

    /**
     A rectangle view show image download progress on the top
    */
    public lazy var indicator: UIView = {
        let indicator = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 4))
        indicator.backgroundColor = UIColor(hex: 0x277AAC)
        indicator.userInteractionEnabled = false
        return indicator
    }()
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = dataSource else {
            return
        }
        
        currentPage = fromIndex
        collectionView.setContentOffset(CGPointMake(CGFloat(currentPage) * view.frame.width, 0), animated: false)
        
        addGesture()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(indicator)
    }
    
//    override public func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    override public func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .None
    }
}

// MARK: - Gesture

extension UNPhotoBrowser {
    private func addGesture() {
        // Gesture
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        tap.requireGestureRecognizerToFail(doubleTap)
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(longPress)
        view.addGestureRecognizer(doubleTap)
    }
    
    func tap(recognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func longPress(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == .Began) {
            let vc = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let saveAction = UIAlertAction(title: "保存照片到相册", style: .Default) { _ in
                self.currentPhotoCell?.saveImageToAlbum()
            }
            vc.addAction(cancelAction)
            vc.addAction(saveAction)
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func doubleTap(recognizer: UITapGestureRecognizer) {
        if let cell = currentPhotoCell {
             if cell.scrollView.zoomScale <= 1 {
                let location = recognizer.locationInView(cell.imageView)
                
                let width = cell.frame.width / 2
                let height = cell.frame.height / 2
                
                let x = location.x - width / 2
                let y = location.y - height / 2
                
                cell.scrollView.zoomToRect(CGRectMake(x, y, width, height), animated: true)
             } else {
                cell.scrollView.setZoomScale(1, animated: true)
            }
            
        }
    }
    
    private func hiddeBar() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.pageControl.frame = CGRectOffset(self.pageControl.frame, 0, self.view.frame.height - self.pageControl.frame.minY)
            }, completion: nil)
    }
    
    private func showBar() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.pageControl.frame = CGRectOffset(self.pageControl.frame, 0, -(self.pageControl.frame.height + 12))
            }, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension UNPhotoBrowser: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UNPhotoBrowserId, forIndexPath: indexPath) as! UNPhotoCell
        if let dataSource = dataSource {
            cell.imageView.frame = cell.bounds
            self.indicator.hidden = false
            let URL = dataSource.bmiddleURLs?[indexPath.item] ?? dataSource.originalURLs[indexPath.item]
            
            if let image = fromImageViews?[indexPath.item].image {
                let imageScale = image.size.width / image.size.height
                let screenScale = cell.frame.width / cell.frame.height
                let size = CGSizeMake(cell.frame.width, cell.frame.width / imageScale)
                if (imageScale < screenScale) {
                    cell.imageView.frame = CGRect(origin: CGPointZero, size: size)
                    cell.scrollView.contentSize = size
                } else {
                    cell.imageView.frame.size = size
                    cell.imageView.center = cell.scrollView.center
                    cell.scrollView.contentSize = cell.frame.size
                }
            }
            
            cell.imageView.yy_setImageWithURL(URL, placeholder: fromImageViews?[indexPath.item].image, options: YYWebImageOptions.ProgressiveBlur, progress: { (receivedSize, totalSize) -> () in
                    self.indicator.frame = CGRectMake(0, 0, CGFloat(receivedSize)/CGFloat(totalSize) * self.view.bounds.width, 4)
                }, transform: nil, completion: { (image, _, _, _, _) -> Void in
                    if let image = image {
                        let imageScale = image.size.width / image.size.height
                        let screenScale = cell.frame.width / cell.frame.height
                        let size = CGSizeMake(cell.frame.width, cell.frame.width / imageScale)
                        if (imageScale < screenScale) {
                            cell.imageView.frame = CGRect(origin: CGPointZero, size: size)
                            cell.scrollView.contentSize = size
                        } else {
                            cell.imageView.frame.size = size
                            cell.imageView.center = cell.scrollView.center
                            cell.scrollView.contentSize = cell.frame.size
                        }
                        self.indicator.hidden = true
                    }
            })
//            cell.imageView.kf_setImageWithURL(URL,
//                            placeholderImage: fromImageViews?[indexPath.item].image,
//                                 optionsInfo: nil,//[.Options: KingfisherOptions.CacheMemoryOnly],
//                               progressBlock: { (receivedSize, totalSize) -> () in
//                                self.indicator.frame = CGRectMake(0, 0, CGFloat(receivedSize)/CGFloat(totalSize) * self.view.bounds.width, 4)
//                               },
//                           completionHandler: { (image, _, _, _) -> () in
//                            self.indicator.hidden = true
//                            if let image = image {
//                                let imageScale = image.size.width / image.size.height
//                                let screenScale = cell.frame.width / cell.frame.height
//                                let size = CGSizeMake(cell.frame.width, cell.frame.width / imageScale)
//                                if (imageScale < screenScale) {
//                                    cell.imageView.frame = CGRect(origin: CGPointZero, size: size)
//                                    cell.scrollView.contentSize = size
//                                } else {
//                                    cell.imageView.frame.size = size
//                                    cell.imageView.center = cell.scrollView.center
//                                    cell.scrollView.contentSize = cell.frame.size
//                                }
//                                
//                            }
//            })
            return cell
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension UNPhotoBrowser: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let itemCell = cell as! UNPhotoCell
        itemCell.scrollView.contentOffset.y = 0
        itemCell.scrollView.setZoomScale(1, animated: false)
    }
}

// MARK: - UNPhotoTransion

public class UNPhotoPushTransion: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! UNPhotoBrowser
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        guard let container = transitionContext.containerView() else { return }
        let toImageView = toVC.fromImageViews![toVC.fromIndex]
        let snapshotView = UIImageView(frame: toImageView.superview!.convertRect(toImageView.frame, toView: fromVC.view))
        snapshotView.clipsToBounds = true
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.image = toImageView.image
        
        toImageView.hidden = true
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        let backgroundView = UIView(frame: toVC.view.frame)
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        container.addSubview(backgroundView)
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)
        
        var imageScale: CGFloat = 0
        var screenScale: CGFloat = 0
        var size: CGSize = toVC.view.bounds.size
        if let image = snapshotView.image {
            imageScale = image.size.width / image.size.height
            screenScale = toVC.view.frame.width / toVC.view.frame.height
            size = CGSizeMake(toVC.view.frame.width, toVC.view.frame.width / imageScale)
        }

        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            if (imageScale < screenScale) {
                snapshotView.frame = CGRect(origin: CGPointZero, size: size)
                
            } else {
                snapshotView.frame.size = size
                snapshotView.center = toVC.view.center
            }
            backgroundView.alpha = 1
             
            }) { _ in
                toVC.view.alpha = 1
                toImageView.hidden = false
                snapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}

public class UNPhotoPopTransion: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! UNPhotoBrowser
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        guard let container = transitionContext.containerView() else { return }
        
        let fromImageView = fromVC.fromImageViews![fromVC.currentPage]
        let snapshotView = UIImageView(frame: fromVC.currentPhotoCell!.imageView.frame)
        snapshotView.clipsToBounds = true
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.image = fromImageView.image
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        fromImageView.hidden = true
        
        let backgroundView = UIView(frame: toVC.view.frame)
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 1
        container.addSubview(backgroundView)
        container.insertSubview(toVC.view, aboveSubview: fromVC.view)
        container.addSubview(snapshotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            snapshotView.frame = fromImageView.superview!.convertRect(fromImageView.frame, toView: toVC.view)
            fromVC.view.alpha = 0
            backgroundView.alpha = 0
            }) { _ in
                fromVC.currentPhotoCell!.hidden = false
                fromImageView.hidden = false
                snapshotView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}



private let UNPhotoBrowserId = "UNPhotoBrowserId"