//
//  Game.swift
//  Set+Concentration
//
//  Created by Madalina Sinca on 10/09/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct Game {
    //MARK: - Constants
    
    struct Constants {
        static let initialCardCount = 12
        
        struct Score {
            static let bonusTimeInterval = 0.0...7.0
            static let defaultTimeInterval = 7.0...15.0
            static let bonusPoints = 2
            static let defaultPoints = 1
        }
    }
    
    //MARK: - Private Properties
    
    private var deck = CardDeck()
    
    //MARK: - Read-Only Properties
    
    private(set) var score = 0
    private(set) var iosScore = 0
    private(set) var set = false
    private(set) var playVersusIos = false
    private(set) var cardsSets = [[SetCard]]()
    private(set) var cardsHint = [SetCard]()
    private(set) var startTime = Date()
    private(set) var endTime = Date()
    
    //MARK: - Public Properties
    
    var cardsSelected = [SetCard]()
    var cardsOnTable = [SetCard]()
    var cardsToRemove = [SetCard]()
    var deckCount: Int { return deck.cards.count }
    
    //MARK: - Computed Properties
    
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
                    scoreAdjusterAccordingToTime()
                    cardsSets.append(cardsSelected)
                    score += scoreBonus()
                    cardsToRemove = cardsSelected
                    startTime = Date()
                case false:
                    score += scorePenalty()
                }
            }
        }
    }
    
    //MARK: - Init Method
    
    init() {
        dealCards(Constants.initialCardCount) { deal() }
    }
    
    //MARK: - Game Methods
    
    private mutating func scoreAdjusterAccordingToTime() {
        endTime = Date()
        let timeInterval: Double = endTime.timeIntervalSince(startTime)
        
        switch timeInterval {
        case Constants.Score.bonusTimeInterval:
            score += Constants.Score.bonusPoints
        case Constants.Score.defaultTimeInterval:
            score += Constants.Score.defaultPoints
        default:
            score += 0
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        let chosenCard = cardsOnTable[index]
        
        if cardsSelected.contains(chosenCard) && cardsSelected.count < 3 {
            cardsSelected = cardsSelected.filter() { $0 != chosenCard }
        } else {
            cardsSelected.append(chosenCard)
        }
        
        if cardsSelected.count == 3 {
            isSet = isSet
        }
    }
    
    mutating func reset() {
        self = Game()
    }
    
    mutating func dealThreeCards() {
        dealCards(3) { deal() }
        score += scorePenalty()
    }
    
    mutating func replaceMatchedCards() -> [Int]{
        var indicesToReplace = [Int]()
        for cardSelected in cardsToRemove {
            let indexForChange = cardsOnTable.index(of: cardSelected)
            if cardsOnTable.count <= 12, let card = deck.deal() {
                cardsOnTable[indexForChange!] = card
                indicesToReplace.append(indexForChange!)
            }
        }
        return indicesToReplace.sorted(by: {$0 < $1})
    }
    
    mutating func removeMatchedCards() {
        for cardSelected in cardsToRemove {
            let indexForChange = cardsOnTable.index(of: cardSelected)
            cardsOnTable.remove(at: indexForChange!)
        }
    }
    
    mutating func giveHint() {
        cardsSelected.removeAll()
        cardsHint.removeAll()
        cardsHint = cardsOnTable.getSetCards() { $0.isSet() }
        score += Score.hint.rawValue
    }
}

//MARK: - Extensions

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

extension Notification.Name {
    static let noCardsSelected = Notification.Name("No cards selected!")
}