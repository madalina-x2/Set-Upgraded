//
//  Concentration.swift
//  Concentration
//
//  Created by Madalina Sinca on 02/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Concentration {
    
    // MARK: - Read-only Properties
    
    private(set) var cards = [ConcentrationCard]()
    private(set) var flipsCount = 0
    
    // MARK: - Private Properties
    
    private var indexOfOneAndOnlyFaceUpCard: Int? = nil
    private var previouslyFlippedCards = [Int]()
    private var startTime = Date()
    private var endTime = Date()
    
    // MARK: - Public Properties
    
    var score = 0
    
    // MARK: - Init Methods
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        indexOfOneAndOnlyFaceUpCard = nil
        shuffleCards()
    }
    
    // MARK: - Game Methods
    
    mutating func turnCardsFaceDownExcept(cardWithIndex index: Int) {
        for flipDownIndex in cards.indices {
            cards[flipDownIndex].isFaceUp = false
        }
        cards[index].isFaceUp = true
        indexOfOneAndOnlyFaceUpCard = index
    }
        
    mutating func chooseCard(at index: Int) {
        if cards[index].isMatched { return }
        
        guard let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index else {
            turnCardsFaceDownExcept(cardWithIndex: index)
            return
        }
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
        }
    }
    
    mutating func increaseFlipCount() {
        flipsCount += 1
    }
    
    mutating func resetFlipCount() {
        flipsCount = 0
    }
    
    // MARK: - Auxiliary Methods
    
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
}
