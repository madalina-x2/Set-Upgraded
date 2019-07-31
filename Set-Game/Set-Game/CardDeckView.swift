//
//  CardDeckView.swift
//  Set-Game
//
//  Created by Madalina Sinca on 29/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class CardDeckView: UIView {

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = #colorLiteral(red: 0.3879515921, green: 0.5529641509, blue: 0.5518316984, alpha: 1)
        rectColor.setFill()
        roundedRect.fill()
    }

}

extension CardDeckView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.03
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.70
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
