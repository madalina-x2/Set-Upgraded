//
//  UIViewExtensions.swift
//  Set+Concentration
//
//  Created by Madalina Sinca on 10/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func removeShadow() {
        layer.shadowOpacity = 0.0
        setNeedsDisplay(); setNeedsLayout()
    }
    
    func reconfigureShadow() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = CGSize(width: -(layer.frame.size.width / 10), height: layer.frame.size.width / 10)
        layer.shadowOpacity = 0.5
        setNeedsDisplay(); setNeedsLayout()
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -(layer.frame.size.width / 10), height: layer.frame.size.width / 10)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
