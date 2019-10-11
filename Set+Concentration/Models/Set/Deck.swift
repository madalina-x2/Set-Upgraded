//
//  Deck.swift
//  Set+Concentration
//
//  Created by Madalina Sinca on 10/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct CardDeck {
    
    //MARK: - Private Properties
    
    private(set) var cards = [SetCard]()
    
    //MARK: - Overriden Methods
    
    init() {
        for number in SetCard.Number.all {
            for symbol in SetCard.Symbol.all {
                for decoration in SetCard.Decoration.all {
                    for color in SetCard.Color.all {
                        cards.append(SetCard(number: number,
                                          symbol: symbol,
                                          decoration: decoration,
                                          color: color))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    //MARK: - Auxiliary Methods
    
    mutating func deal() -> SetCard? {
        if cards.isEmpty {
            return nil
        }
        return cards.removeLast()
    }
}
