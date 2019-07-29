//
//  Game.swift
//  Set-Game
//
//  Created by Madalina Sinca on 16/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Game {
    
    private var deck = CardDeck()
    var deckCount: Int { return deck.cards.count }
    
    private(set) var score = 0
    private(set) var iosScore = 0
    private(set) var set = false
    private(set) var playVersusIos = false
    
    private(set) var cardsOnTable = [Card]()
    var cardsSelected = [Card]()
    private(set) var cardsSets = [[Card]]()
    private(set) var cardsHint = [Card]()
    
    private(set) var startTime = Date()
    private(set) var endTime = Date()

    
    init() {
        dealCards(12) { deal() }
    }
    
    var isSet: Bool? {
        get {
            if cardsSelected.count == 3 {
                return cardsSelected.isSet()
            } else { return nil }
        }
        set {
            if let newValue = newValue {
                set = newValue
                switch newValue {
                case true:
                    timer()
                    cardsSets.append(cardsSelected)
                    score += scoreBonus()
                    replaceOrRemoveCard()
                    cardsSelected.removeAll()
                    startTime = Date()
                case false:
                    cardsSelected.removeAll()
                    score += scorePenalty()
                }
            } else { cardsSelected.removeAll() }
        }
    }
    
    mutating func timer() {
        endTime = Date()
        let timeInterval: Double = endTime.timeIntervalSince(startTime)
        
        switch timeInterval {
        case 0...7:
            score += 2
        case 7...15:
            score += 1
        default:
            score += 0
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        let chosenCard = cardsOnTable[index]
        
        if cardsSelected.contains(chosenCard), cardsSelected.count < 3{
            cardsSelected = cardsSelected.filter() { $0 != chosenCard }
        } else {
            switch cardsSelected {
            // if = 3 cards, check for SET match
            case let cardsForSet where cardsForSet.count == 3:
                isSet = isSet
                cardsSelected.removeAll();
                cardsSelected.append(chosenCard)
            // if < 3 => add chosen card to selected
            case let cardsForSet where !cardsForSet.contains(chosenCard):
                cardsSelected.append(chosenCard)
            // not a match, start building a set from currently chosen card
            default: break
            }
        }
    }
    
    mutating func reset() {
        self = Game.init()
    }
    
    mutating func dealThreeCards() {
        dealCards(3) { deal() }
    }
    
    private mutating func replaceOrRemoveCard() {
        for cardSelected in cardsSelected {
            let indexForChange = cardsOnTable.index(of: cardSelected)
            
            if cardsOnTable.count <= 12, let card = deck.deal() {
                cardsOnTable[indexForChange!] = card
            } else {
                cardsOnTable.remove(at: indexForChange!)
            }
        }
    }
    
    func isEnd() -> Bool {
        // TODO
        // how to check when it's over
        return false
    }
    
    mutating func giveHint() {
        cardsSelected.removeAll()
        cardsHint.removeAll()
        cardsHint = cardsOnTable.getSetCards() { $0.isSet() }
        score += Score.hint.rawValue
    }
}

// EXTENSIONS

private extension Array where Element == Card {
    func isSet() -> Bool {
        let number     = Set(self.map { $0.number } )
        let symbol     = Set(self.map { $0.symbol } )
        let decoration = Set(self.map { $0.decoration } )
        let color      = Set(self.map { $0.color } )
        
        return  number.count != 2 && symbol.count != 2 && decoration.count != 2 && color.count != 2
    }
}

private extension Array where Element: Equatable {
    func getSetCards(_ closure: (_ check: [Element]) -> (Bool)) -> [Element] {
        for i in 0..<self.count  {
            for j in (i + 1)..<self.count {
                for k in (j + 1)..<self.count {
                    let result = [self[i],self[j],self[k]]
                    if closure(result) {
                        return result
                    }
                }
            }
        }
        return []
    }
}

private extension Game {
    
    enum Score: Int {
        case bonus, penalty, hint = -5
    }
    
    mutating func deal() {
        if let card = deck.deal() {
            cardsOnTable.append(card)
        }
    }
    
    func dealCards(_ dealingCount: Int, closure: ()->()) {
        if dealingCount < 1 {
            return
        }
        for _ in 1...dealingCount { closure() }
    }
    
    func scoreBonus() -> Int {
        print("cards on table: \(cardsOnTable.count))")
        switch cardsOnTable.count {
        case 27: return 1
        case 24: return 2
        case 21: return 3
        case 18: return 4
        case 15: return 5
        default: return 6
        }
    }
    
    func scorePenalty() -> Int {
        return scoreBonus() - 7
    }
}
