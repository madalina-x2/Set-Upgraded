//
//  CardDeckView.swift
//  Set-Game
//
//  Created by Madalina Sinca on 29/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class CardDeckView: UIView {
    
    var cardSpawningPoint: CGRect! {
        return CGRect(x: 0, y: bounds.height - 15, width: 15, height: 15)
    }
    var cardRetreatingPoint: CGRect! {
        return CGRect(x: bounds.width - 15, y: bounds.height - 15, width: 15, height: 15)
    }
    lazy var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: bounds.insetBy(dx: 10, dy: 10))

    //MARK: - Overriden Methods
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = #colorLiteral(red: 0.3879515921, green: 0.5529641509, blue: 0.5518316984, alpha: 1)
        rectColor.setFill()
        roundedRect.fill()
    }
}

//MARK: - Extension
extension CardDeckView {
    private var cornerRadius: CGFloat {
        return bounds.size.height * CardView.Constants.SizeRatio.cornerRadiusToBoundsHeight
    }
}
