//
//  ViewController.swift
//  Set-Game
//
//  Created by Madalina Sinca on 15/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Private Outlets
    
    @IBOutlet weak private var setCountLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var deckCountLabel: UILabel!
    @IBOutlet weak private var setInformLabel: UILabel!
    @IBOutlet weak private var iosLabel: UILabel!
    @IBOutlet weak private var dealCardsButton: UIButton!
    @IBOutlet weak private var cardDeckView: CardDeckView! {
        didSet {
            let swipeDownForExtraCards = UISwipeGestureRecognizer(target: self, action: #selector(dealCards(_:)))
            swipeDownForExtraCards.direction = .down
            cardDeckView.addGestureRecognizer(swipeDownForExtraCards)
            cardDeckView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards)))
        }
    }
    
    //MARK: - Private Properties
    
    private var game = Game()
    private var hintCardViews = [CardView]()
    private var dealtCardViews = [CardView]()
    private lazy var animator = UIDynamicAnimator(referenceView: cardDeckView)
    private lazy var cardBehaviour = CardViewBehaviour(in: animator)
    private enum UpdateViewCase { case initView, touchCard, giveHint, shuffle, deal3 }
    private var cardViews = [CardView]() { didSet { cardViews.enumerated().forEach({$0.element.tag = $0.offset})}}
    private var selectedCardViews: [CardView] {
        var selectedViews = [CardView]()
        for card in game.cardsSelected {
            if let index = game.cardsOnTable.index(of: card) {
                selectedViews.append(cardViews[index])
            }
        }
        
        for card in game.cardsOnTable {
            if game.cardsSelected.contains(card) {
                if let index = game.cardsOnTable.index(of: card) {
                    cardViews[index].setCardViewState(state: .selected)
                }
            } else {
                if let index = game.cardsOnTable.index(of: card) {
                    cardViews[index].setCardViewState(state: .normal)
                }
            }
        }
        return selectedViews
    }
    private var removableCardViews: [CardView] {
        var removableViews = [CardView]()
        for card in game.cardsToRemove {
            if let index = game.cardsOnTable.index(of: card) {
                removableViews.append(cardViews[index])
            }
        }
        return removableViews
    }
    
    //MARK: - Button Actions
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        dealCardsButton.isEnabled = true
        iosLabel.alpha = 0.0
        updateViewFromModel(inCase: .initView)
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        if game.deckCount == 0 {
            dealCardsButton.isEnabled = false
        } else {
            game.dealThreeCards()
            updateViewFromModel(inCase: .deal3)
        }
    }
    
    @IBAction func giveHint(_ sender: UIButton) {
        game.giveHint()
        hintCardViews.removeAll()
        for (index, card) in game.cardsOnTable.enumerated() {
            if game.cardsHint.contains(card) {
                hintCardViews.append(cardViews[index])
            }
        }
        updateViewFromModel(inCase: .giveHint)
    }
    
    //MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardDeckView.grid = Grid(layout: .aspectRatio(CGFloat(0.625)),
                                 frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
        updateViewFromModel(inCase: .initView)
    }
    
    //MARK: - Auxiliary Methods
    
    @objc func shuffleCards() {
        game.cardsOnTable.shuffle()
        updateViewFromModel(inCase: .shuffle)
    }
    
    private func populate(card: Card, onScreen: Bool, inCase: UpdateViewCase) {
        let newCardView = CardView(frame: view.frame, color: card.color.rawValue, number: card.number, decoration: card.decoration.rawValue, symbol: card.symbol.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        newCardView.addGestureRecognizer(tap)
        if let indexOfCard = game.cardsOnTable.index(of: card) {
            cardViews.insert(newCardView, at: indexOfCard)
        }
    }
    
    //MARK: - UI Methods
    
    private func updateInfoLabels() {
        deckCountLabel.text = "DECK: \(game.deckCount)"
        scoreLabel.text = "SCORE: \(game.score)"
        setCountLabel.text = "SETS: \(game.cardsSets.count)"
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        guard let currentView = gesture.view else {
            return
        }
        game.chooseCard(at: currentView.tag)
        _ = selectedCardViews
        updateViewFromModel(inCase: .touchCard)
    }
    
    private func displayCardsAccordingToGrid(onScreen: Bool, inCase: UpdateViewCase, indicesForReplace: [Int] = [Int]()) {
        cardDeckView.grid.cellCount = cardViews.count
        
        if inCase == .deal3 {
             for index in indicesForReplace {
                let cardView = cardViews[index]
                cardView.frame = cardDeckView.cardSpawningPoint
                cardView.isFaceUp = false
                cardView.alpha = 0.0
                cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                cardDeckView.addSubview(cardView)
            }
        } else {
            for (index, cardView) in cardViews.enumerated() {
                if onScreen {
                    cardView.frame = cardDeckView.grid[index]!
                    cardView.isFaceUp = false
                    cardView.alpha = 1.0
                } else {
                    cardView.frame = cardDeckView.cardSpawningPoint
                    cardView.alpha = 0.0
                }
                cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                cardDeckView.addSubview(cardView)
            }
        }
    }
    
    private func clearCardDeckView() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    private func updateCardViews(onScreen: Bool) {
        clearCardDeckView()
        for card in game.cardsOnTable {
            populate(card: card, onScreen: onScreen, inCase: .initView)
        }
        displayCardsAccordingToGrid(onScreen: onScreen, inCase: .initView)
    }
    
    private func updateViewFromModel(inCase: UpdateViewCase) {
        switch inCase {
        case .initView:
            updateInfoLabels()
            updateCardViews(onScreen: false)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0,
                delay: 0.5,
                options: [],
                animations: {},
                completion: cardBehaviour.animateNewCards(in: cardDeckView, cardsToAnimate: cardViews, delay: 1.0)
            )
            updateInfoLabels()
            
        case .touchCard:
            if removableCardViews.count == 3, game.isSet == true {
                for removableCardView in removableCardViews {
                    cardBehaviour.snapTo(retreatingPoint: cardDeckView.cardRetreatingPoint, cardView: removableCardView)
                }
                let tagsToRemove = removableCardViews.map({$0.tag}).sorted(by: {$0>$1})
                tagsToRemove.forEach({cardViews.remove(at: $0)})
                if game.cardsOnTable.count == 12 {
                    let indicesToReplace = game.replaceMatchedCards()
                    for indexToReplace in indicesToReplace {
                        populate(card: game.cardsOnTable[indexToReplace], onScreen: false, inCase: .deal3)
                    }
                    displayCardsAccordingToGrid(onScreen: false, inCase: .deal3, indicesForReplace: indicesToReplace)
                    
                    for indexToReplace in indicesToReplace {
                        cardBehaviour.animateFromSpawningPointToIndex(cardDeckView: cardDeckView, cardView: cardViews[indexToReplace], delay: 1, index: indexToReplace)
                    }
                } else {
                    game.removeMatchedCards()
                    cardDeckView.grid.cellCount = cardViews.count
                    cardBehaviour.animateGridReconfig(in: cardDeckView, cardsToAnimate: cardViews, delay: 0)
                }
                game.cardsToRemove.removeAll()
                game.cardsSelected.removeAll()
                
                updateInfoLabels()
            } else if game.cardsSelected.count == 3, game.isSet == false {
                let dummyCardViews = selectedCardViews
                
                for cardView in dummyCardViews {
                    cardView.setCardViewState(state: .mismatched)
                }
                
                game.cardsSelected.removeAll()
                updateInfoLabels()
            }
            
        case .giveHint:
            for cardView in cardViews {
                if hintCardViews.contains(cardView) == false {
                    cardDeckView.sendSubview(toBack: cardView)
                }
            }
            cardBehaviour.animateHint(cardViews: hintCardViews)
            updateInfoLabels()
        
        case .deal3:
            let arraySlice = game.cardsOnTable.suffix(3)
            let dealtCards = Array(arraySlice)
            for card in dealtCards {
                populate(card: card, onScreen: false, inCase: .deal3)
            }
            displayCardsAccordingToGrid(onScreen: false, inCase: .deal3, indicesForReplace: Array((game.cardsOnTable.count - 3)..<game.cardsOnTable.count))
            let arraySlice2 = cardViews.suffix(3)
            let dealtCardViews = Array(arraySlice2)
            let arraySlice3 = cardViews.prefix(cardViews.count - 3)
            let cardsToReconfigure = Array(arraySlice3)
            cardBehaviour.animateGridReconfig(in: cardDeckView, cardsToAnimate: cardsToReconfigure, delay: 0)
            cardBehaviour.animateFromSpawningPoint(cardDeckView: cardDeckView, cardViews: dealtCardViews, delay: 0.1 * Double(cardViews.count), index: cardsToReconfigure.count)
            updateInfoLabels()
        //case .shuffle:
        default:
            updateCardViews(onScreen: false)
        }
    }
}
