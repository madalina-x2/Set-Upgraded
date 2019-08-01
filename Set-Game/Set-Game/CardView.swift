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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setLayout()
    }
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
        rectColor.setFill()
        roundedRect.fill()
        
//        let path1 = diamond(upperCenterPoint: CGPoint(x: frame.width / 2, y: 2 * frame.height / 6.5))
//        let path2 = diamond(upperCenterPoint: CGPoint(x: frame.width / 2, y: 3 * frame.height / 6.5))
//        let path3 = diamond(upperCenterPoint: CGPoint(x: frame.width / 2, y: 4 * frame.height / 6.5))
//        path1.fill()
//        path2.fill()
//        path3.fill()
        
//        let path1 = oval(upperLeftPoint: CGPoint(x: frame.width / 3, y: 2 * frame.height / 6.5))
//        let path2 = oval(upperLeftPoint: CGPoint(x: frame.width / 3, y: 3 * frame.height / 6.5))
//        let path3 = oval(upperLeftPoint: CGPoint(x: frame.width / 3, y: 4 * frame.height / 6.5))
//        path1.fill()
//        path2.fill()
//        path3.fill()
        
//        let path1 = squiggle(upperCenterPoint: CGPoint(x: frame.width / 2, y: 2 * frame.height / 6.5))
//        let path2 = squiggle(upperCenterPoint: CGPoint(x: frame.width / 2, y: 3 * frame.height / 6.5))
//        let path3 = squiggle(upperCenterPoint: CGPoint(x: frame.width / 2, y: 4 * frame.height / 6.5))
//        path1.fill()
//        path2.fill()
//        path3.fill()
    }
    
    private func diamond(upperCenterPoint: CGPoint) -> UIBezierPath {
        let diamondDiagonal = frame.height / 8
        let lowerCenterPoint = CGPoint(x: upperCenterPoint.x, y: upperCenterPoint.y + diamondDiagonal)
        let leftMidPoint = CGPoint(x: upperCenterPoint.x - diamondDiagonal, y: upperCenterPoint.y + diamondDiagonal / 2)
        let rightMidPoint = CGPoint(x: upperCenterPoint.x + diamondDiagonal, y: upperCenterPoint.y + diamondDiagonal / 2)
        let path = UIBezierPath()
        
        path.move(to: upperCenterPoint)
        path.addLine(to: rightMidPoint)
        path.addLine(to: lowerCenterPoint)
        path.addLine(to: leftMidPoint)
        path.close()
        UIColor.gray.setFill()
        
        return path
    }
    
    private func oval(upperLeftPoint: CGPoint) -> UIBezierPath {
        let upperRightPoint = CGPoint(x: upperLeftPoint.x + frame.width / 3, y: upperLeftPoint.y)
        let lowerLeftPoint = CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y + frame.height / 12)
        let lowerRightPoint = CGPoint(x: lowerLeftPoint.x + frame.width / 3, y: lowerLeftPoint.y)
        
        let ovalLength = upperRightPoint.x - upperLeftPoint.x
        
        let upperLeftControlPoint = CGPoint(x: upperLeftPoint.x - ovalLength / 3, y: upperLeftPoint.y)
        let upperRightControlPoint = CGPoint(x: upperRightPoint.x + ovalLength / 3, y: upperRightPoint.y)
        let lowerLeftControlPoint = CGPoint(x: upperLeftPoint.x - ovalLength / 3, y: lowerLeftPoint.y)
        let lowerRightControlPoint = CGPoint(x: upperRightPoint.x + ovalLength / 3, y: lowerRightPoint.y)
        let path = UIBezierPath()
        
        path.move(to: upperLeftPoint)
        path.addLine(to: upperRightPoint)
        path.addCurve(to: lowerRightPoint, controlPoint1: upperRightControlPoint, controlPoint2: lowerRightControlPoint)
        path.addLine(to: lowerLeftPoint)
        path.addCurve(to: upperLeftPoint, controlPoint1: lowerLeftControlPoint, controlPoint2: upperLeftControlPoint)
        UIColor.gray.setFill()
        
        return path
    }
    
    private func squiggle(upperCenterPoint: CGPoint) -> UIBezierPath {
        let squiggleWidth = frame.width / 10
        let lowerCenterPoint = CGPoint(x: upperCenterPoint.x, y: upperCenterPoint.y + squiggleWidth)
        let upperLeftPoint = CGPoint(x: upperCenterPoint.x - squiggleWidth*2, y: upperCenterPoint.y)
        let upperRightPoint = CGPoint(x: upperCenterPoint.x + squiggleWidth*2, y: upperCenterPoint.y)
        let lowerLeftPoint = CGPoint(x: lowerCenterPoint.x - squiggleWidth*2, y: lowerCenterPoint.y)
        let lowerRightPoint = CGPoint(x: lowerCenterPoint.x + squiggleWidth*2, y: lowerCenterPoint.y)
        
        let halfSquiggleWidth = squiggleWidth / 1.5
        let controlPoint1 = CGPoint(x: upperLeftPoint.x - halfSquiggleWidth, y: upperLeftPoint.y - halfSquiggleWidth)
        let controlPoint2 = CGPoint(x: upperCenterPoint.x - halfSquiggleWidth, y: upperCenterPoint.y - halfSquiggleWidth)
        let controlPoint3 = CGPoint(x: upperCenterPoint.x + halfSquiggleWidth, y: upperCenterPoint.y + halfSquiggleWidth)
        let controlPoint4 = CGPoint(x: upperRightPoint.x, y: upperRightPoint.y + halfSquiggleWidth)
        let controlPoint5 = CGPoint(x: lowerRightPoint.x + halfSquiggleWidth, y: lowerRightPoint.y + halfSquiggleWidth)
        let controlPoint6 = CGPoint(x: lowerCenterPoint.x + halfSquiggleWidth, y: lowerCenterPoint.y + halfSquiggleWidth)
        let controlPoint7 = CGPoint(x: lowerCenterPoint.x - halfSquiggleWidth, y: lowerCenterPoint.y - halfSquiggleWidth)
        let controlPoint8 = CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y - halfSquiggleWidth)
        
        let path = UIBezierPath()
        
        path.move(to: lowerLeftPoint)
        path.addCurve(to: upperCenterPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        path.addCurve(to: upperRightPoint, controlPoint1: controlPoint3, controlPoint2: controlPoint4)
        path.addCurve(to: lowerCenterPoint, controlPoint1: controlPoint5, controlPoint2: controlPoint6)
        path.addCurve(to: lowerLeftPoint, controlPoint1: controlPoint7, controlPoint2: controlPoint8)
        
        UIColor.black.setStroke()
        path.lineWidth = 1
        path.stroke()
        
        return path
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
