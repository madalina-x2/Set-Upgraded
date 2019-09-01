//
//  ViewController.swift
//  Set-Game
//
//  Created by Madalina Sinca on 15/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Private Properties
    private var game = Game()
    private var playAgainstIos = false
    private var iosWonRound = false
    private var timer: Timer?
    
    @IBOutlet weak var cardSpawningPointButton: UIButton!
    @IBOutlet weak var cardRetreatingPointButton: UIButton!
    
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
    private var cardViews = [CardView]()
    private var hintCardViews = [CardView]()
    private var selectedCardViews = [CardView]()
    private var dealtCardViews = [CardView]()
    lazy var animator = UIDynamicAnimator(referenceView: cardDeckView)
    lazy var cardBehaviour = CardViewBehaviour(in: animator)
    
    //MARK: - Button Actions
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel(inCase: .initView)
        cardBehaviour.animateFromSpawningPoint(cardDeckView: cardDeckView, cardViews: cardViews, delay: 1.0, index: 0)
        
        playAgainstIos = false
        timer?.invalidate()
        iosWonRound = false
        iosLabel.text = "iOS:"
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        game.dealThreeCards()
        updateViewFromModel(inCase: .deal3)
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
    
    @IBAction func playAgainstIos(_ sender: UIButton) {
        game.reset()
        playAgainstIos = true
        iosLabel.text = "iOS: 🤔"
        waitForFunc(duration: 10, selector: #selector(self.iosTurn))
        updateViewFromModel(inCase: .updateLabels)
    }
    
    //MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardDeckView.cardSpawningPoint = cardDeckView.convert(cardSpawningPointButton!.frame, from: cardSpawningPointButton!.superview)
        cardDeckView.cardRetreatingPoint = cardDeckView.convert(cardRetreatingPointButton!.frame, from: cardRetreatingPointButton!.superview)
        
        cardDeckView.grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
        updateViewFromModel(inCase: .initView)
    }
    
    //MARK: - Auxiliary Methods
    
    @objc func shuffleCards() {
        game.cardsOnTable.shuffle()
        updateViewFromModel(inCase: .shuffle)
    }
    
    @objc func iosEnterRound() {
        cardViews.forEach { (cardView) in
            cardView.isUserInteractionEnabled = false
        }
        iosWonRound = true
        game.giveHint()
        updateViewFromModel(inCase: .giveHint)
        iosLabel.text = "iOS: 😂"
        waitForFunc(duration: 2.0, selector: #selector(self.iosMakeSet))
    }
    
    @objc func iosMakeSet() {
        game.cardsSelected.removeAll()
        game.cardsSelected = game.cardsHint
        //updateViewFromModel()
        game.isSet = game.isSet
        waitForFunc(duration: 2.0, selector: #selector(self.iosExitRound))
    }
    
    @objc func iosExitRound() {
        iosLabel.text = "iOS: 🤔"
        
        updateViewFromModel(inCase: .updateLabels)
        cardViews.forEach { (cardView) in
            cardView.isUserInteractionEnabled = true
        }
        iosWonRound = false
        waitForFunc(duration: 10, selector: #selector(self.iosTurn))
    }
    
    @objc func iosTurn() {
        iosLabel.text = "iOS: 😁"
        waitForFunc(duration: 2.0, selector: #selector(self.iosEnterRound))
    }
    
    func waitForFunc(duration: TimeInterval, selector: Selector) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: selector, userInfo:nil, repeats: false)
    }
    
    @objc func clearLabel() {
        setInformLabel.text = ""
        setInformLabel.alpha = 0.0
    }
    
    //MARK: - UI Methods
    
    private func updateInfoLabels() {
        deckCountLabel.text = "DECK: \(game.deckCount)"
        scoreLabel.text = "SCORE: \(game.score)"
        setCountLabel.text = "SETS: \(game.cardsSets.count)"
    }
    
    private func didSelectValidSet() {
        self.setInformLabel.text = "✅"
        self.setInformLabel.textColor = .green
        if playAgainstIos, !iosWonRound {
            waitForFunc(duration: 10, selector: #selector(self.iosTurn))
            iosLabel.text = "iOS: 😢"
        }
    }
    
    private func didSelectInvalidSet() {
        self.setInformLabel.text = "𝗫"
        self.setInformLabel.textColor = .red
    }
    
    private func didSelectSet() {
        if self.game.isSet == true {
            didSelectValidSet()
        } else {
            didSelectInvalidSet()
        }
    }
    
    private func set(cardView: CardView, selected: Bool) {
        if selected {
            cardView.changeBackgroundColor()
        } else {
            cardView.changeBackgroundColor()
        }
    }
    
    private func setCardViewBackgroundColor(cardView: CardView, card: Card) {
        if game.cardsSelected.count == 3, game.cardsSelected.contains(card) {
            if game.cardsSelected.isSet() == true {
                cardView.changeBackgroundColor()
                return
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.changeBackgroundColor()
                }) { (_) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.set(cardView: cardView, selected: self.game.cardsSelected.contains(card))
                    })
                }
                return
            }
        }
        set(cardView: cardView, selected: game.cardsSelected.contains(card))
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        guard let currentView = gesture.view else {
            return
        }
        game.chooseCard(at: currentView.tag)
        if selectedCardViews.count == 3 {
            selectedCardViews.removeAll()
        }
        selectedCardViews.append(cardViews[currentView.tag])
        cardViews[currentView.tag].setCardViewState(state: .selected)
        updateViewFromModel(inCase: .touchCard)
    }
    
    private func displayCardsAccordingToGrid(onScreen: Bool, inCase: UpdateViewCase) {
        cardDeckView.grid.cellCount = cardViews.count
        
        if inCase == .deal3 {
            let arraySlice = cardViews.suffix(3)
            let dealtCardViews = Array(arraySlice)
             for cardView in dealtCardViews {
                cardView.frame = cardDeckView.cardSpawningPoint
                cardView.alpha = 0.0
                cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                cardDeckView.addSubview(cardView)
            }
        } else {
            for (index, cardView) in cardViews.enumerated() {
                if onScreen {
                    cardView.frame = cardDeckView.grid[index]!
                    cardView.isFaceUp = true
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
    
    private func populate(card: Card, onScreen: Bool, inCase: UpdateViewCase) {
        let newCardView = CardView(frame: view.frame, color: card.color.rawValue, number: card.number.rawValue, decoration: card.decoration.rawValue, symbol: card.symbol.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        newCardView.tag = cardViews.count
        newCardView.addGestureRecognizer(tap)
        cardViews.append(newCardView)
        //setCardViewBackgroundColor(cardView: newCardView, card: card)
        displayCardsAccordingToGrid(onScreen: onScreen, inCase: inCase)
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
    }
    
    private enum UpdateViewCase {
        case initView, touchCard, giveHint, shuffle, deal3, updateLabels
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
            
        case .touchCard:
            for cardView in cardViews {
                if selectedCardViews.contains(cardView) == false {
                    cardView.setCardViewState(state: .normal)
                }
            }
            if selectedCardViews.count == 3 {
                for selectedCardView in selectedCardViews {
                    cardBehaviour.snapTo(retreatingPoint: cardDeckView.cardRetreatingPoint, cardView: selectedCardView)
                }
            }
            
        case .updateLabels:
            updateInfoLabels()
            didSelectSet()
            
        case .giveHint:
            for cardView in cardViews {
                if hintCardViews.contains(cardView) == false {
                    cardDeckView.sendSubview(toBack: cardView)
                }
            }
            cardBehaviour.animateHint(cardViews: hintCardViews)
        
        case .deal3:
            let arraySlice = game.cardsOnTable.suffix(3)
            let dealtCards = Array(arraySlice)
            for card in dealtCards {
                populate(card: card, onScreen: false, inCase: .deal3)
            }
            let arraySlice2 = cardViews.suffix(3)
            let dealtCardViews = Array(arraySlice2)
            let arraySlice3 = cardViews.prefix(cardViews.count - 3)
            let cardsToReconfigure = Array(arraySlice3)
            cardBehaviour.animateGridReconfig(in: cardDeckView, cardsToAnimate: cardsToReconfigure, delay: 0)
            cardBehaviour.animateFromSpawningPoint(cardDeckView: cardDeckView, cardViews: dealtCardViews, delay: 3, index: cardsToReconfigure.count)
        default:
            updateCardViews(onScreen: false)
        }
        
        if game.cardsSelected.count == 3 {
            didSelectSet()
        }
        
    }
}
