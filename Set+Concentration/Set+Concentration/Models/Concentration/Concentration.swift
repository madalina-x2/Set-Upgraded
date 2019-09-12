//
//  Concentration.swift
//  Concentration
//
//  Created by Madalina Sinca on 02/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation
import GameplayKit

struct Concentration {
    
    // MARK: - Properties
    
    private(set) var cards = [ConcentrationCard]()
    var flipsCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var score = 0
    var previouslyFlippedCards = [Int]()
    var startTime = Date()
    var endTime = Date()
    
    // MARK: - Methods
    
    mutating func timer() {
        endTime = Date()
        let timeInterval: Double = endTime.timeIntervalSince(startTime)
        
        switch timeInterval {
        case 0...0.5:
            score += 2
        case 0.5...1:
            score += 1
        default:
            score += 0
        }
    }
    
    mutating func increaseFlipCount() {
        flipsCount += 1
    }
    
    mutating func resetFlipCount() {
        flipsCount = 0
    }
        
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index is not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                timer()
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    startTime = Date()
                    
                    var cardWasFlipped = false
                    var matchWasFlipped = false
                    
                    for chosenCardIdentifier in previouslyFlippedCards.indices {
                        if cards[index].identifier == previouslyFlippedCards[chosenCardIdentifier] {
                            score -= 1
                            cardWasFlipped = true
                        }
                        
                        if cards[matchIndex].identifier == previouslyFlippedCards[chosenCardIdentifier] {
                            score -= 1
                            matchWasFlipped = true
                        }
                    }
                    
                    if !cardWasFlipped {
                        previouslyFlippedCards += [cards[index].identifier]
                    }
                    
                    if !matchWasFlipped {
                        previouslyFlippedCards += [cards[matchIndex].identifier]
                    }
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        shuffleCards()
    }
    
    mutating func shuffleCards() {
        for _ in 0..<cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(0, randomIndex)
        }
    }
    
    mutating func resetGame() {
        flipsCount = 0
        
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            indexOfOneAndOnlyFaceUpCard = nil
        }
    }
}
