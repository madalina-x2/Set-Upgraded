//
//  CardView.swift
//  Set-Game
//
//  Created by Madalina Sinca on 29/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    //MARK: - Constants
    struct Constants {
        struct Colors {
            static let borderColorWhenSelected = #colorLiteral(red: 0.8037576079, green: 0.7561692855, blue: 0.6305327289, alpha: 1)
            static let borderColorWhenNotSelected = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
        }
        struct SizeRatio {
            static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
            static let cornerRadiusToBoundsHeight: CGFloat = 0.06
            static let cornerOffsetToCornerRadius: CGFloat = 0.33
            static let faceCardImageSizeToBoundsSize: CGFloat = 0.70
        }
    }
    
    //MARK: - Private Properties
    private var symbols = [UIBezierPath]()

    //MARK: - Overridden Methods

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
        rectColor.setFill()
        roundedRect.fill()
    }
    
    private func drawCardOnScreen() {
        //TODO
    }
    
    private func makeRoundedEdges(to rect: UIBezierPath, with cornerRadius: CGFloat){
        //TODO
    }
    
    private func setBackgroundColor(to rect: UIBezierPath, with color: UIColor){
//        let rectColor = color
//        rectColor.setFill()
//        rect.fill()
    }
}

//MARK: - Extensions

extension CardView {
    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.SizeRatio.cornerRadiusToBoundsHeight
    }
}
