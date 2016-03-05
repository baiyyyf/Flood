//
//  FDProfileView.swift
//  Flood
//
//  Created by byyyf on 3/4/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit
import YYWebImage

class FDProfileView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var AiphaView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var followsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.clipsToBounds = true
    }

    func setData(user: WBUser) {
        backgroundImageView.yy_setImageWithURL(NSURL(string: user.coverImageURL ?? user.coverImagePhoneURL), placeholder: nil)
        avatarImageView.yy_setImageWithURL(NSURL(string: user.lAvatarURL), placeholder: nil, options: YYWebImageOptions.IgnoreAnimatedImage, progress: nil, transform: { (image, _) -> UIImage! in
            return image.ScaledToSizeWithRound(HomeConfig.avatarSize)
            }, completion: nil)
        userNameLabel.text = user.screenName
        userDescriptionLabel.text = user.userDescription
        followsLabel.text = "\(user.friendsCount)\n关注"
        followersLabel.text = "\(user.followersCount)\n粉丝"
        tweetsLabel.text = "\(user.statusesCount)\n微博"
    }
}
