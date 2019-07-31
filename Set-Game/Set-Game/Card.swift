//
//  Card.swift
//  Set-Game
//
//  Created by Madalina Sinca on 16/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Card {
    
    //MARK: - Properties
    
    let number: Number
    let symbol: Symbol
    let decoration: Decoration
    let color: Color
    
    //MARK: - Enums
    
    enum Number: Int {
        case one, two, three
        var description: String { return String(rawValue + 1) }
        static let all = [Number.one, .two, .three]
    }
    
    enum Symbol: String {
        case triangle, circle, square
        var description: String { return rawValue }
        static let all = [Symbol.triangle, .circle, .square]
    }
    
    enum Decoration: String {
        case striped, filled, outline
        var description: String { return rawValue }
        static let all = [Decoration.striped, .filled, .outline]
    }
    
    enum Color: String {
        case red, green, purple
        var description: String { return rawValue }
        static let all = [Color.red, .green, .purple]
    }
}

//MARK: - Extensions

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return  lhs.number == rhs.number &&
            lhs.symbol == rhs.symbol &&
            lhs.decoration == rhs.decoration &&
            lhs.color == rhs.color
    }
}

extension Card {
    var description: String {
        return "\(number.rawValue) \(symbol.rawValue) \(decoration.rawValue) \(color.rawValue)\n"
    }
}
