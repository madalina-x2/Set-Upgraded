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
        
        let path = squiggle(upperLeftPoint: CGPoint(x: frame.width / 3, y: 3 * frame.height / 6.5))
        path.fill()
    }
    
    private func circle(centerPoint: CGPoint) -> UIBezierPath {
        return UIBezierPath(arcCenter: centerPoint, radius: self.frame.height/6, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
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
    
    private func squiggle(upperLeftPoint: CGPoint) -> UIBezierPath {
        let squiggleWidth = frame.width / 12
        let lowerLeftPoint = CGPoint(x: upperLeftPoint.x + frame.width / 15, y: upperLeftPoint.y + squiggleWidth)
        let upperRightPoint = CGPoint(x: upperLeftPoint.x + frame.width / 5, y: upperLeftPoint.y + squiggleWidth / 2)
        let lowerRightPoint = CGPoint(x: upperRightPoint.x + frame.width / 15, y: upperRightPoint.y + squiggleWidth)
        
        let upperMidPoint = CGPoint(x: lowerRightPoint.x, y: upperLeftPoint.y)
        let lowerMidPoint = CGPoint(x: upperLeftPoint.x, y: lowerRightPoint.y)
        
        let upperLeftControlPoint = CGPoint(x: upperLeftPoint.x - squiggleWidth, y: upperLeftPoint.y + squiggleWidth)
        let upperRightControlPoint = CGPoint(x: upperRightPoint.x + squiggleWidth, y: upperRightPoint.y - squiggleWidth)
        let lowerLeftControlPoint = CGPoint(x: upperLeftPoint.x - squiggleWidth, y: lowerLeftPoint.y + squiggleWidth)
        let lowerRightControlPoint = CGPoint(x: upperRightPoint.x + squiggleWidth, y: lowerRightPoint.y - squiggleWidth)
        
        let path = UIBezierPath()
        
        path.move(to: upperLeftPoint)
        path.addLine(to: upperRightPoint)
        path.addLine(to: upperMidPoint)
        path.addCurve(to: lowerRightPoint, controlPoint1: upperRightControlPoint, controlPoint2: lowerRightControlPoint)
        
        //path.control
        //path.move(to: lowerRightPoint)
        path.addLine(to: lowerLeftPoint)
        path.addLine(to: lowerMidPoint)
        path.addCurve(to: upperLeftPoint, controlPoint1: lowerLeftControlPoint, controlPoint2: upperLeftControlPoint)
        
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
