//
//  StatusCellDelegate.swift
//  Flood
//
//  Created by byyyf on 3/2/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import Foundation
import BFLabel

protocol StatusCellDelgate: BFLabelDelegate {
    func touchedImage(index: Int, imageViews: [UIImageView], photos: [WBPhotoDisplayData])
}
