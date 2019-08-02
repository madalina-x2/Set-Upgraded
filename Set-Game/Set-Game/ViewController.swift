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
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak private var setCountLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var deckCountLabel: UILabel!
    @IBOutlet weak private var setInformLabel: UILabel!
    @IBOutlet weak private var iosLabel: UILabel!
    @IBOutlet weak private var dealCardsButton: UIButton!
    // assignment 3:
    @IBOutlet weak private var cardDeckView: CardDeckView! {
        didSet {
            let swipeDownForExtraCards = UISwipeGestureRecognizer(target: self, action: #selector(dealCards(_:)))
            swipeDownForExtraCards.direction = .down
            cardDeckView.addGestureRecognizer(swipeDownForExtraCards)
            cardDeckView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards)))
            
            //let tapToSelectCard = UITapGestureRecognizer(taget: self)
        }
    }
    //lazy private var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds)
    private var cardViews = [CardView]()
    
    //MARK: - Button Actions
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
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
    
    //TODO touchCard method
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    //MARK: - Auxiliary Methods
    
    @objc func shuffleCards() {
        cardViews.shuffle()
        // update view ?
    }
    
    @objc func iosEnterRound() {
        cardButtons.forEach { (button) in
            button.isEnabled = false
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
        cardButtons.forEach { (button) in
            button.isEnabled = true
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
    
    private func set(cardView: CardView, selected: Bool){
        if selected {
            cardView.backgroundColor = CardView.Constants.Colors.colorWhenSelected
        } else {
            cardView.backgroundColor = CardView.Constants.Colors.colorWhenNotSelected
        }
    }
    
    private func setCardViewBackgroundColor(cardView: CardView, card: Card) {
        if game.cardsHint.contains(card) {
            cardView.backgroundColor = CardView.Constants.Colors.colorWhenGivingHint
        }
        if game.cardsSelected.count == 3, game.cardsSelected.contains(card) {
            if self.game.isSet == true {
                cardView.backgroundColor = CardView.Constants.Colors.colorWhenCorretSet
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.backgroundColor = CardView.Constants.Colors.colorWhenIncorrectSet
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
        guard let aView = gesture.view else {
            return
        }
        print("tap card view at index: \(aView.tag)")
        game.chooseCard(at: aView.tag)
        updateViewFromModel()
    }
    
    private func populate(card: Card) {
        let newCardView = CardView(frame: view.frame, color: card.color.rawValue, number: card.number.rawValue, decoration: card.decoration.rawValue, symbol: card.symbol.rawValue)
        newCardView.tag = cardViews.count
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        newCardView.addGestureRecognizer(tap)
        
        cardViews.append(newCardView)
        
        setCardViewBackgroundColor(cardView: newCardView, card: card)
        
        var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
        grid.cellCount = cardViews.count
        
        for (index, cardView) in cardViews.enumerated() {
            cardView.frame = grid[index]!
            cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
            cardDeckView.addSubview(cardView)
        }
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
        updateCardViews()
    }
}
