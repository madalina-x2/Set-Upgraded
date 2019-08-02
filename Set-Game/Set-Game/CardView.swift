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
            static let colorWhenSelected = #colorLiteral(red: 0.7455085054, green: 0.6910808031, blue: 0.8037576079, alpha: 1)
            static let colorWhenNotSelected = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
            static let colorWhenGivingHint = #colorLiteral(red: 0.9764705896, green: 0.9558855858, blue: 0.7371077641, alpha: 1)
            static let colorWhenCorretSet = #colorLiteral(red: 0.7741263415, green: 0.8862745166, blue: 0.6670993155, alpha: 1)
            static let colorWhenIncorrectSet = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
        struct SizeRatio {
            static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
            static let cornerRadiusToBoundsHeight: CGFloat = 0.06
            static let cornerOffsetToCornerRadius: CGFloat = 0.33
            static let faceCardImageSizeToBoundsSize: CGFloat = 0.70
        }
    }
    
    struct CardProperties {
        var color = ""
        var number = 1
        var decoration = ""
        var symbol = ""
    }
    
    //MARK: - Private Properties
    //private var symbols = [UIBezierPath]()
    private(set) var cardProperties = CardProperties(color: "", number: 1, decoration: "", symbol: "")

    //MARK: - Overridden Methods
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayout()
//    }
    
    init(frame: CGRect, color : String, number : Int, decoration : String, symbol: String) {
        cardProperties.color = color
        cardProperties.number = number
        cardProperties.decoration = decoration
        cardProperties.symbol = symbol
        //setupLayout()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
        rectColor.setFill()
        roundedRect.fill()
        drawCardOnScreen()
    }
    
    func setupLayout() {
        self.layer.borderWidth = 2
        self.clipsToBounds = true
        self.contentMode = .redraw
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
        self.layer.borderColor = CardView.Constants.Colors.colorWhenNotSelected.cgColor
        
        var cardColor = UIColor()
        switch cardProperties.color {
        case "red":
            cardColor = #colorLiteral(red: 0.8035931587, green: 0.3512506187, blue: 0.459513247, alpha: 1)
        case "green":
            cardColor = #colorLiteral(red: 0.2272136807, green: 0.6645996571, blue: 0.6210204363, alpha: 1)
        default:
            cardColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
        var symbolOriginPoints = [CGPoint]()
        var divider = CGFloat()
        if (cardProperties.symbol == "oval") {
            divider = 3.0
        } else { divider = 2.0}
        let xCoordinate = frame.width / divider
        let yCoordinate = frame.height / 6.5
        switch cardProperties.number {
        case 1:
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 3*yCoordinate))
        case 2:
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 2.5*yCoordinate))
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 3.5*yCoordinate))
        default:
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 2*yCoordinate))
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 3*yCoordinate))
            symbolOriginPoints.append(CGPoint(x: xCoordinate, y: 4*yCoordinate))
        }
        
        var symbols = [UIBezierPath]()
        switch cardProperties.symbol {
        case "squiggle":
            for originPoint in symbolOriginPoints {
                symbols.append(squiggle(upperCenterPoint: originPoint))
            }
        case "oval":
            for originPoint in symbolOriginPoints {
                symbols.append(self.oval(upperLeftPoint: originPoint))
            }
        default:
            for originPoint in symbolOriginPoints {
                symbols.append(diamond(upperCenterPoint: originPoint))
            }
        }
        
        switch cardProperties.decoration {
        case "outline":
            Constants.Colors.colorWhenNotSelected.setFill()
        case "striped":
            // TODO stripes
            cardColor = cardColor.withAlphaComponent(0.5)
            cardColor.setFill()
        default:
            cardColor.setFill()
        }
        
        cardColor.setStroke()
        
        for symbol in symbols {
            symbol.lineWidth = 3
            symbol.stroke()
            symbol.fill()
        }
    }
    
    private func makeRoundedEdges(to rect: UIBezierPath, with cornerRadius: CGFloat){
        //TODO
    }
    
}

//MARK: - Extensions

extension CardView {
    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.SizeRatio.cornerRadiusToBoundsHeight
    }
}
