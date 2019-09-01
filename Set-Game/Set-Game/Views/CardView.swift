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
            static let colorWhenSelected = #colorLiteral(red: 0.7302725191, green: 0.7204900723, blue: 0.6328923217, alpha: 1)
            static let colorWhenNotSelected = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
            static let colorWhenGivingHint = #colorLiteral(red: 0.9764705896, green: 0.9558855858, blue: 0.7371077641, alpha: 1)
            static let colorWhenCorrectSet = #colorLiteral(red: 0.7741263415, green: 0.8862745166, blue: 0.6670993155, alpha: 1)
            static let colorWhenIncorrectSet = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
        struct SizeRatio {
            static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        }
    }
    
    //MARK: - Private Properties
    private struct CardProperties {
        var color: String
        var number: Int
        var decoration: String
        var symbol: String
    }

    private var cardProperties = CardProperties(color: "", number: 1, decoration: "", symbol: "")
    private var roundedRect = UIBezierPath()
    private var currentCardColor = UIColor()
    var isFaceUp = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    private(set) var currentState: CardState = .normal {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    enum CardState {
        case normal, selected, hint, matched, mismatched
    }
    
    //MARK: - Overriden Methods
    init(frame: CGRect, color : String, number : Int, decoration : String, symbol: String) {
        cardProperties.color = color
        cardProperties.number = number
        cardProperties.decoration = decoration
        cardProperties.symbol = symbol
        currentCardColor = Constants.Colors.colorWhenNotSelected
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override func draw(_ rect: CGRect) {
        initCard()
        changeBackgroundColor()
        drawCardOnScreen()
    }
    
    //MARK: - Auxiliary Methods

    private func drawStripes() -> UIBezierPath {
        let path = UIBezierPath()
        let xStride = frame.width / 10
        let yStride = frame.height / 10
        
        var origin = CGPoint(x: frame.width, y: 0.0)
        var destination = CGPoint(x: 0.0, y: frame.height)
        
        while origin.x > destination.x {
            path.move(to: origin)
            path.addLine(to: destination)
            
            origin.x -= xStride
            destination.y -= yStride
        }
        
        origin = CGPoint(x: frame.width, y: 0.0)
        destination = CGPoint(x: 0.0, y: frame.height)
        while origin.y < destination.y {
            path.move(to: origin)
            path.addLine(to: destination)

            origin.y += yStride
            destination.x += xStride
        }
        
        return path
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
        
        return path
    }
    
    private func getCardColor(cardProperties: CardProperties) -> UIColor {
        switch cardProperties.color {
        case "red":
            return #colorLiteral(red: 0.8035931587, green: 0.3512506187, blue: 0.459513247, alpha: 1)
        case "green":
            return #colorLiteral(red: 0.2272136807, green: 0.6645996571, blue: 0.6210204363, alpha: 1)
        default:
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
    
    private func getSymbolOriginPoints(cardProperties: CardProperties) -> [CGPoint] {
        var symbolOriginPoints = [CGPoint]()
        var divider = CGFloat()
        divider = cardProperties.symbol == "oval" ? 3.0 : 2.0
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
        
        return symbolOriginPoints
    }
    
    private func getSymbolPaths(cardProperties: CardProperties, symbolOriginPoints: [CGPoint]) -> [UIBezierPath] {
        var symbols = [UIBezierPath]()
        switch cardProperties.symbol {
        case "squiggle":
            for originPoint in symbolOriginPoints {
                symbols.append(self.squiggle(upperCenterPoint: originPoint))
            }
        case "oval":
            for originPoint in symbolOriginPoints {
                symbols.append(self.oval(upperLeftPoint: originPoint))
            }
        default:
            for originPoint in symbolOriginPoints {
                symbols.append(self.diamond(upperCenterPoint: originPoint))
            }
        }
        return symbols
    }
    
    func setCardViewState(state: CardState) {
        self.currentState = state
    }
    
    //MARK: - UI Methods
    private func drawCardOnScreen() {
        if isFaceUp {
            let cardColor = getCardColor(cardProperties: cardProperties)
            let symbolOriginPoints = getSymbolOriginPoints(cardProperties: cardProperties)
            let symbols = getSymbolPaths(cardProperties: cardProperties, symbolOriginPoints: symbolOriginPoints)
            
            var stripeyPath = UIBezierPath()
            switch cardProperties.decoration {
            case "outline":
                Constants.Colors.colorWhenNotSelected.setFill()
            case "striped":
                Constants.Colors.colorWhenNotSelected.setFill()
                stripeyPath = drawStripes()
            default:
                cardColor.setFill()
            }
            
            cardColor.setStroke()
            for symbol in symbols {
                UIGraphicsGetCurrentContext()?.saveGState()
                symbol.lineWidth = 3
                symbol.stroke()
                symbol.fill()
                symbol.addClip()
                stripeyPath.stroke()
                UIGraphicsGetCurrentContext()?.restoreGState()
            }
        }
    }
    
    func drawBorder() {
        alpha = 1.0
        layer.cornerRadius = Constants.SizeRatio.cornerRadiusToBoundsHeight
        layer.borderWidth = 2.0
        
        switch currentState {
        case .normal:
            layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            layer.borderWidth = 0.0
        case .selected:
            layer.borderColor = #colorLiteral(red: 0.5147541761, green: 0.4750006795, blue: 0.43709144, alpha: 1)
        case .matched:
            layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case .mismatched:
            layer.borderColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case .hint:
            layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
    }
    
    func changeBackgroundColor() {
        switch currentState {
        case .selected:
            currentCardColor = Constants.Colors.colorWhenSelected
        case .hint:
            currentCardColor = Constants.Colors.colorWhenGivingHint
        case .matched:
            currentCardColor = Constants.Colors.colorWhenCorrectSet
        case .mismatched:
            currentCardColor = Constants.Colors.colorWhenIncorrectSet
        default:
            currentCardColor = Constants.Colors.colorWhenNotSelected
        }
    }
    
    func setupLayout() {
        self.layer.borderWidth = 2
        self.clipsToBounds = true
        self.contentMode = .redraw
    }
    
    private func initCard() {
        roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        let rectColor = currentCardColor
        rectColor.setFill()
        roundedRect.fill()
        self.dropShadow()
    }
}

//MARK: - Extensions
extension CardView {
    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.SizeRatio.cornerRadiusToBoundsHeight
    }
}
