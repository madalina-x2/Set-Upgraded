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
        if cards.isEmpty {
            return nil
        }
        return cards.removeLast()
    }
}
