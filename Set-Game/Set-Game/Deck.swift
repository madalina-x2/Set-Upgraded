//
//  Deck.swift
//  Set-Game
//
//  Created by Madalina Sinca on 16/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct CardDeck {
    
    private(set) var cards = [Card]()
    
    init() {
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for decoration in Card.Decoration.all {
                    for color in Card.Color.all {
                        cards.append(Card(number: number,
                                          symbol: symbol,
                                          decoration: decoration,
                                          color: color))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func deal() -> Card? {
        if cards.count > 0 {
            return cards.removeLast()
        } else {
            return nil
        }
    }
}

extension Int {
    var arc4random: Int {
        if self >= 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        return -Int(arc4random_uniform(UInt32(abs(self))))
    }
}

extension Array {
    mutating func shuffle() {
        for index in stride(from: count - 1, through: 1, by: -1) {
            let randomIndex = (index + 1).arc4random
            if index != randomIndex {
                self.swapAt(index, randomIndex)
            }
        }
    }
}
