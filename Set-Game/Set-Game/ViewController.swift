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
    lazy private var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
    lazy var animator = UIDynamicAnimator(referenceView: cardDeckView)
    lazy var cardBehaviour = CardViewBehaviour(in: animator)
    
    //MARK: - Button Actions
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
        playAgainstIos = false
        timer?.invalidate()
        iosWonRound = false
        iosLabel.text = "iOS:"
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        game.dealThreeCards()
        updateViewFromModel()
    }
    
    @IBAction func giveHint(_ sender: UIButton) {
        game.giveHint()
        updateViewFromModel()
    }
    
    @IBAction func playAgainstIos(_ sender: UIButton) {
        game.reset()
        playAgainstIos = true
        iosLabel.text = "iOS: 🤔"
        waitForFunc(duration: 10, selector: #selector(self.iosTurn))
        updateViewFromModel()
    }
    
    //MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardDeckView.cardSpawningPoint = cardDeckView.convert(cardSpawningPointButton!.frame, from: cardSpawningPointButton!.superview)
        cardDeckView.cardRetreatingPoint = cardDeckView.convert(cardRetreatingPointButton!.frame, from: cardRetreatingPointButton!.superview)
        
        grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
        updateViewFromModel()
    }
    
    
    
    //MARK: - Auxiliary Methods
    
    @objc func shuffleCards() {
        game.cardsOnTable.shuffle()
        updateViewFromModel()
    }
    
    @objc func iosEnterRound() {
        cardViews.forEach { (cardView) in
            cardView.isUserInteractionEnabled = false
        }
        iosWonRound = true
        game.giveHint()
        updateViewFromModel()
        iosLabel.text = "iOS: 😂"
        waitForFunc(duration: 2.0, selector: #selector(self.iosMakeSet))
    }
    
    @objc func iosMakeSet() {
        game.cardsSelected.removeAll()
        game.cardsSelected = game.cardsHint
        updateViewFromModel()
        game.isSet = game.isSet
        waitForFunc(duration: 2.0, selector: #selector(self.iosExitRound))
    }
    
    @objc func iosExitRound() {
        iosLabel.text = "iOS: 🤔"
        
        updateViewFromModel()
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
    
    private func set(cardView: CardView, selected: Bool){
        if selected {
            cardView.changeBackgroundColor(type: "selected")
        } else {
            cardView.changeBackgroundColor(type: "not selected")
        }
    }
    
    private func setCardViewBackgroundColor(cardView: CardView, card: Card) {
        if game.cardsHint.contains(card) {
           cardView.changeBackgroundColor(type: "hint")
            return
        }
        if game.cardsSelected.count == 3, game.cardsSelected.contains(card) {
            if game.cardsSelected.isSet() == true {
                cardView.changeBackgroundColor(type: "valid set")
                return
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.changeBackgroundColor(type: "invalid set")
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
        //updateViewFromModel()
        setCardViewBackgroundColor(cardView: cardViews[currentView.tag], card: game.cardsOnTable[currentView.tag])
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0,
            delay: 0.5,
            options: [],
            animations: {},
            completion: cardBehaviour.flipOver(cardViews[currentView.tag])
        )
        
//        cardBehaviour.snapTo(retreatingPoint: self.cardDeckView.cardRetreatingPoint! , cardView: self.cardViews[currentView.tag])
        
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(
//            withTimeInterval: 3.0,
//            repeats: false,
//            block: { _ in
//                self.cardBehaviour.snapTo(retreatingPoint: self.cardDeckView.cardRetreatingPoint , cardView: self.cardViews[currentView.tag])
//            }
//        )
        
        cardBehaviour.spin360(cardViews[currentView.tag], duration: 1.0, delay: 0.7)
    }
    
    private func displayCardsAccordingToGrid() {
        grid.cellCount = cardViews.count
        
        for (index, cardView) in cardViews.enumerated() {
            cardView.frame = grid[index]!
            cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
            cardDeckView.addSubview(cardView)
        }
    }
    
    private func populate(card: Card) {
        let newCardView = CardView(frame: view.frame, color: card.color.rawValue, number: card.number.rawValue, decoration: card.decoration.rawValue, symbol: card.symbol.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        newCardView.tag = cardViews.count
        newCardView.addGestureRecognizer(tap)
        cardViews.append(newCardView)
        setCardViewBackgroundColor(cardView: newCardView, card: card)
        displayCardsAccordingToGrid()
    }
    
    private func clearCardDeckView() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        cardViews.removeAll()
    }
    
    private func updateCardViews() {
        clearCardDeckView()
        for card in game.cardsOnTable {
            populate(card: card)
        }
    }
    
    private func updateViewFromModel() {
        updateInfoLabels()
        if game.cardsSelected.count == 3 {
            didSelectSet()
        }
        updateCardViews()
    }
}
