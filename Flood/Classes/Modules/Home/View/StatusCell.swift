//
//  StatusCell.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import BFLabel
import YYWebImage

class StatusCell: UITableViewCell {

    private var bottomSpacing: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.92, alpha: 1).CGColor
        layer.frame.size = CGSize(width: screenWidth, height: HomeConfig.cellSpacing)
        layer.opaque = true
        return layer
    }()
    
    private var bottomLine = CALayer()
    
    private var tweetBottomLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        layer.frame.size = CGSize(width: screenWidth, height: 0.5)
        layer.opaque = true
        return layer
    }()
    
    private var retweetBottomLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        layer.frame.size = CGSize(width: screenWidth, height: 0.5)
        layer.opaque = true
        return layer
    }()

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(
            origin: CGPoint(x: horMargin, y: HomeConfig.avatarTopMargin),
            size: HomeConfig.avatarSize)
        )
        imageView.opaque = false
        return imageView
    }()
    
    private lazy var tweetLabel: BFLabel = {
        let view = BFLabel()
        view.frame = CGRect(x: 0, y: HomeConfig.headerHeight, width: screenWidth, height: 0)
        self.setupLabel(view)
        return view
    }()
    
    private lazy var retweetLabel: BFLabel = {
        let view = BFLabel()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0)
        self.setupLabel(view)
        return view
    }()
    
    private var photoContainer: UIView = {
        let width = FDConfig.contentWidth
        let view = UIView(frame: CGRect(x: horMargin, y: 0, width: width, height: width))
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    private var imageViews = [FDImageView]()
    
    private var repostButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: ceil(screenWidth/3), height: HomeConfig.footerHeight))
        view.setImage(UIImage(named: "repost"), forState: .Normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0)
        return view
    }()
    
    private var commentButton: UIButton = {
        let width = ceil(screenWidth/3)
        let view = UIButton(frame: CGRect(x: width, y: 0, width: width, height: HomeConfig.footerHeight))
        view.setImage(UIImage(named: "comment"), forState: .Normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0)
        return view
    }()
    
    private var praiseButton: UIButton = {
        let width = ceil(screenWidth/3)
        let view = UIButton(frame: CGRect(x: width*2, y: 0, width: width, height: HomeConfig.footerHeight))
        view.setImage(UIImage(named: "praise"), forState: .Normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0)
        return view
    }()
    
    private var avatarNameFrame = CGRect(x: horMargin + 8 + HomeConfig.avatarHeight, y: HomeConfig.avatarTopMargin, width: 100, height: 0)
    
    private var renderQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    weak var delegate: StatusCellDelgate? {
        didSet {
            tweetLabel.delegate = delegate
            retweetLabel.delegate = delegate
        }
    }
    
    var model: WBStatusDisplayData! {
        didSet { makeUI() }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.layer.doubleSided = false
        contentView.layer.contentsScale = UIScreen.mainScreen().scale
        contentView.layer.contentsGravity = kCAGravityTopLeft
        contentView.userInteractionEnabled = false
        backgroundColor = FDConfig.cellBackgroundColor
        selectionStyle = .None
        
        contentView.opaque = true
        opaque = true
        
        insertSubview(tweetLabel, belowSubview: contentView)
        insertSubview(retweetLabel, belowSubview: contentView)
        contentView.addSubview(avatarImageView)
        addSubview(photoContainer)
        
        
        let topLine = createSeperatorLine()
        topLine.frame.size = CGSize(width: screenWidth, height: 0.5)
        let midLine = createSeperatorLine()
        midLine.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        midLine.frame = CGRect(x: horMargin, y: HomeConfig.headerHeight, width: screenWidth - horMargin, height: 0.5)
        bottomLine = createSeperatorLine()
        bottomLine.frame.size = CGSize(width: screenWidth, height: 0.5)
        contentView.layer.addSublayer(topLine)
        contentView.layer.addSublayer(midLine)
        contentView.layer.addSublayer(bottomSpacing)
        contentView.layer.addSublayer(tweetBottomLine)
        contentView.layer.addSublayer(retweetBottomLine)
        contentView.layer.addSublayer(bottomLine)
        contentView.addSubview(repostButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(praiseButton)
        addImageViewsToContainer()
    }
    
    func setupLabel(label: BFLabel) {
        label.insets = UIEdgeInsetsMake(verMargin, horMargin, verMargin, horMargin)
        label.displayLayer = self.contentView.layer
        label.backgroundColor = nil
        //label.delegate = self
    }
    
    private func addImageViewsToContainer() {
        let pictureHeight = HomeConfig.smallPictureHeight
        let offset = pictureHeight + HomeConfig.imageMargin
        for y in 0..<3 {
            for x in 0..<3 {
                let imageView = FDImageView(frame: CGRect( x: CGFloat(x) * offset, y: CGFloat(y) * offset,
                    width: pictureHeight, height: pictureHeight))
                imageView.contentMode = .ScaleAspectFill
                imageView.clipsToBounds = true
                imageView.opaque = true
                
                photoContainer.addSubview(imageView)
                imageViews.append(imageView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.setDisableActions(true)
        if let cellHeight = model?.cellHeight {
            bottomSpacing.frame.origin.y =  cellHeight - HomeConfig.cellSpacing
            bottomLine.frame.origin.y = bottomSpacing.frame.minY
            retweetBottomLine.frame.origin.y =  bottomSpacing.frame.minY - HomeConfig.footerHeight - 1
            if let retweetHeight = model.retweetStatus?.textHeight {
                tweetBottomLine.frame.origin.y = retweetBottomLine.frame.minY - retweetHeight
                tweetBottomLine.hidden = false
            } else {
                tweetBottomLine.hidden = true
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        renderQueue.cancelAllOperations()
        CATransaction.setDisableActions(true)
        imageViews[0].frame.size = HomeConfig.smallPictureSize
        imageViews.forEach { $0.hidden = true }
        imageViews[0].preferredSize = nil
    }
    
    private func makeUI() {
        CATransaction.setDisableActions(true)
        if let lAvatarURL = model.user?.lAvatarURL {
            avatarImageView.yy_setImageWithURL(lAvatarURL, placeholder: nil, options: YYWebImageOptions.IgnoreAnimatedImage, progress: nil, transform: { (image, _) -> UIImage! in
                return image.ScaledToSizeWithRound(HomeConfig.avatarSize)
                }, completion: nil)
        }
        bottomSpacing.frame.origin.y = model.cellHeight - HomeConfig.cellSpacing
        let y = bottomSpacing.frame.origin.y - HomeConfig.footerHeight
        repostButton.frame.origin.y = y
        commentButton.frame.origin.y = y
        praiseButton.frame.origin.y = y
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(13), NSForegroundColorAttributeName: UIColor(white: 0.5, alpha: 1)]
        repostButton.setAttributedTitle(NSAttributedString(string: "\(model.repostsCount)", attributes: attributes), forState: .Normal)
        commentButton.setAttributedTitle(NSAttributedString(string: "\(model.commentsCount)", attributes: attributes), forState: .Normal)
        praiseButton.setAttributedTitle(NSAttributedString(string: "\(model.attitudesCount)", attributes: attributes), forState: .Normal)
        renderQueue.addOperationWithBlock { [weak self] in
            self?.renderTextIntoImage()
        }
        
        if let photos = model.retweetStatus?.photos {
            setPhotosURL(photos, model.retweetStatus!.mediaHeight!)
        } else if let photos = model.photos {
            setPhotosURL(photos, model.mediaHeight!)
        } else {
            photoContainer.hidden = true
        }
    }
    
    private func setPhotosURL(photos: [WBPhotoDisplayData], _ height: CGFloat) {
        CATransaction.setDisableActions(true)
        photoContainer.frame.origin.y = model.cellHeight - HomeConfig.footerHeight - height - verMargin - HomeConfig.cellSpacing
        photoContainer.frame.size.height = height
        switch photos.count {
        case 1:
            let firstImageView = imageViews[0]
            firstImageView.hidden = false
            let photo = photos[0]
            firstImageView.preferredSize = CGSizeMake(FDConfig.contentWidth, HomeConfig.largePictureHeight)
            firstImageView.yy_setImageWithURL(photo.bmiddleURL ?? photo.thumbnailURL, placeholder: nil)
        case 4:
            let newViews = [imageViews[0], imageViews[1], imageViews[3], imageViews[4]]
            for (index, view) in newViews.enumerate() {
                view.hidden = false
                view.yy_setImageWithURL(photos[index].thumbnailURL, placeholder: nil)
            }
        default:
            for (index, photo) in photos.enumerate() {
                imageViews[index].hidden = false
                imageViews[index].yy_setImageWithURL(photo.thumbnailURL, placeholder: nil)
            }
        }
        
        photoContainer.hidden = false
    }
    
    private func renderTextIntoImage() {
        CATransaction.setDisableActions(true)
        tweetLabel.frame.size.height = model.textHeight
        tweetLabel.attributedText = model.attributedText
        if let retweetedModel = model.retweetStatus {
            retweetLabel.frame = CGRect(x: 0, y: tweetLabel.frame.maxY,
                width: screenWidth, height: retweetedModel.textHeight)
            retweetLabel.attributedText = retweetedModel.attributedText
            retweetLabel.hidden = false
        } else {
            retweetLabel.hidden = true
        }
        
        let contextRect = CGRect(x: 0, y: 0, width: screenWidth, height: model.cellHeight)
        UIGraphicsBeginImageContextWithOptions(contextRect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        backgroundColor?.setFill()
        CGContextFillRect(context, contextRect)
        
        if let attributedName = model.user?.attributedName {
            attributedName.drawAtPoint(avatarNameFrame.origin)
        }
        
        let timeY = HomeConfig.avatarTopMargin + HomeConfig.avatarHeight - 12 * unitFontHeight
        model.attributedSinceTime.drawAtPoint(CGPoint(x: avatarNameFrame.minX, y: timeY))
        
        tweetLabel.drawInRect(tweetLabel.frame)
        if (!retweetLabel.hidden) {
            let backgroundRect = CGRect(
                x: 0,
                y: tweetLabel.frame.maxY,
                width: screenWidth,
                height: retweetLabel.frame.height
            )
            UIColor(hex: 0xF7F7F7).setFill()
            CGContextFillRect(context, backgroundRect)
            retweetLabel.drawInRect(retweetLabel.frame)
        }
        
        let imageCG =  UIGraphicsGetImageFromCurrentImageContext().CGImage
        UIGraphicsEndImageContext()
        
        NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] in
            CATransaction.setDisableActions(true)
            self?.contentView.layer.contents = imageCG
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInView(self)
        if (avatarImageView.frame /> p) {
            
        } else if (!photoContainer.hidden && (photoContainer.frame /> p)) {
            let photos = model.retweetStatus?.photos ?? model.photos!
            let p = touches.first!.locationInView(photoContainer)
            if (photos.count == 4) {
                for (i, index) in [0, 1, 3, 4].enumerate() {
                    if (imageViews[index].frame /> p) {
                        delegate?.touchedImage(i, imageViews: imageViews, photos: photos)
                        break
                    }
                }
            } else {
                for (index, imageView) in imageViews.enumerate() where !imageView.hidden && (imageView.frame /> p) {
                    delegate?.touchedImage(index, imageViews: imageViews, photos: photos)
                    break
                }
            }

        }
    }

}

infix operator /> { associativity left }
func />(rect: CGRect, point: CGPoint) -> Bool {
    return CGRectContainsPoint(rect, point)
}

extension StatusCell {
    static func cellHeight(model: WBStatusDisplayData) {
        
        func setHeights(model: WBStatusDisplayData, retweeted: Bool = false) {
            // set text height
            var tmpText = model.attributedText.string
            if let userName = model.user?.attributedName.string where retweeted {
                tmpText = "@\(userName): \(tmpText)"
            }
            let parser = retweeted ? retweetedStatusParser : statusParser
            model.attributedText = parser.parseText(tmpText)
            var textHeight = parser.size(CGSize(width: FDConfig.contentWidth, height: 0)).height
            if (textHeight < 20) {
                let height = unitFontHeight*FDConfig.customConfig.bodyFontSize
                if (textHeight < height) {
                    textHeight = textHeight + 3
                }
            }
            model.textHeight = textHeight
                + verMargin*2
            
            // set photos height
            if let count = model.photos?.count {
                var photosHeight: CGFloat = 0
                switch count {
                case 0:
                    break
                case 1:
                    photosHeight = HomeConfig.largePictureHeight
                default:
                    let numOfLine = ceil(floor(CGFloat(count)/3 - 0.1 + 1))
                    photosHeight = numOfLine * HomeConfig.smallPictureHeight + (numOfLine - 1) * HomeConfig.imageMargin
                }
                model.mediaHeight = photosHeight
                model.textHeight += photosHeight + verMargin
            }
        }
        
        
        if let retweet = model.retweetStatus {
            setHeights(retweet, retweeted: true)
        }
        
        setHeights(model, retweeted: false)
        
        model.cellHeight = HomeConfig.fixedHeight
            + model.textHeight
            + (model.retweetStatus?.textHeight ?? 0)
            + 1
    }
}


let statusParser: FDTextParser = {
    let parser = FDTextParser()
    parser.tintColor = FDConfig.customConfig.tintColor
    parser.imageForName = WBEmoticonPackage.emoticonForName
    parser.font = FDConfig.customConfig.bodyTextFont
    parser.textColor = FDConfig.customConfig.bodyTextColor
    parser.lineSpacing = FDConfig.customConfig.lineSpacing
    return parser
}()

let retweetedStatusParser: FDTextParser = {
    let parser = FDTextParser()
    parser.tintColor = FDConfig.customConfig.tintColor
    parser.imageForName = WBEmoticonPackage.emoticonForName
    parser.font = UIFont.systemFontOfSize(FDConfig.customConfig.bodyFontSize - 1, weight: UIFontWeightLight)
    parser.textColor = FDConfig.customConfig.subTextColor
    parser.lineSpacing = FDConfig.customConfig.lineSpacing
    return parser
}()

func createSeperatorLine() -> CALayer {
    let layer = CALayer()
    layer.backgroundColor = UIColor(white: 0.85, alpha: 1).CGColor
    layer.opaque = true
    return layer
}