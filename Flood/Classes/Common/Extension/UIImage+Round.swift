//
//  UIImage+Round.swift
//  Flood
//
//  Created by byyyf on 3/1/16.
//  Copyright © 2016 byyyf. All rights reserved.
//

import UIKit

extension UIImage {
    func ScaledToSizeWithRound(size: CGSize, borderColor: UIColor = UIColor(white: 0.86, alpha: 1)) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        UIBezierPath(roundedRect: rect, cornerRadius: size.height).addClip()
        let innerRect = rect
        drawInRect(rect)
        let border = UIBezierPath(roundedRect: innerRect, cornerRadius: innerRect.height)
        borderColor.setStroke()
        border.lineWidth = 1
        border.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
