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
        }
    }
    //lazy private var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds)
    private var setCards = [CardView]()
    
    //MARK: - Button Actions
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        //updateViewFromModel()
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        //game.dealThreeCards()
        //updateViewFromModel()
        //var viewArray = [CardView]()
        var grid = Grid(layout: .aspectRatio(CGFloat(0.625)), frame: cardDeckView.bounds.insetBy(dx: 10, dy: 10))
        for _ in 0..<3 {
            setCards.append(CardView())
        }
        grid.cellCount = setCards.count
        for (index, view) in setCards.enumerated() {
            view.frame = grid[index]!
            view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            view.frame = view.frame.insetBy(dx: 5, dy: 5)
            cardDeckView.addSubview(view)
        }
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
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateViewFromModel()
    }
    
    //MARK: - Auxiliary Methods
    
    @objc func shuffleCards() {
        setCards.shuffle()
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
    
    @objc func clearColor(for button: UIButton) {
        button.layer.backgroundColor = #colorLiteral(red: 0.9096221924, green: 0.9060236216, blue: 0.8274506927, alpha: 1)
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
    
    private func setupDealCardsButton() {
        if game.cardsOnTable.count < 27, game.deckCount > 0 {
            dealCardsButton.isEnabled = true
        } else {
            dealCardsButton.isEnabled = false
        }
    }
    
    private func hideCardFromScreen(_ button: UIButton) {
        button.isHidden = true
        button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        button.setTitle("", for: UIControlState.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    }
    
    private func populate(button: UIButton, from card: Card){
        button.setAttributedTitle(attributedStringForCard(card), for: .normal)
        button.isEnabled = true
        button.isHidden = false
        button.layer.cornerRadius = 8.0
    }
    
    private func set(button: UIButton, selected: Bool){
        if selected {
            button.layer.backgroundColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
        } else {
            button.layer.backgroundColor = #colorLiteral(red: 0.9096221924, green: 0.9060236216, blue: 0.8274506927, alpha: 1)
        }
    }
    
    private func setupBackground(of button: UIButton, from card: Card) {
        if game.cardsHint.contains(card){
            button.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.9558855858, blue: 0.7371077641, alpha: 1)
        }
        if game.cardsSelected.count == 3, game.cardsSelected.contains(card) {
            if self.game.isSet == true {
                button.layer.backgroundColor = #colorLiteral(red: 0.7741263415, green: 0.8862745166, blue: 0.6670993155, alpha: 1)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    button.layer.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                }) { (_) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.set(button: button, selected: self.game.cardsSelected.contains(card))
                    })
                }
                return
            }
        }
        set(button: button, selected: game.cardsSelected.contains(card))
    }
    
    private func updateCardButtons() {
        for (index, button) in cardButtons.enumerated() {
            if index >= game.cardsOnTable.count {
                hideCardFromScreen(button)
                continue
            }
            let card = game.cardsOnTable[index]
            
            populate(button: button, from: card)
            setupBackground(of: button, from: card)
        }
    }
    
    private func updateViewFromModel() {
        updateInfoLabels()
        if game.cardsSelected.count == 3 {
            didSelectSet()
        }
        setupDealCardsButton()
        updateCardButtons()
    }
    
    private func attributedStringForCard(_ card: Card) -> NSAttributedString {
        let cardSymbol: String = {
            switch card.symbol {
            case .triangle: return "▲"
            case .circle: return "●"
            case .square: return "■"
            }
        }()
        
        let color: UIColor = {
            switch card.color {
            case .red: return #colorLiteral(red: 0.968746841, green: 0.777038753, blue: 0.3501046896, alpha: 1)
            case .green: return #colorLiteral(red: 0.8050321937, green: 0.3532711267, blue: 0.4588070512, alpha: 1)
            case .purple: return #colorLiteral(red: 0.2275798917, green: 0.6626726985, blue: 0.6195083261, alpha: 1)
            }
        }()
        
        let strokeWidth: CGFloat = {
            switch card.decoration {
            case .striped: return -15
            case .filled: return -15
            case .outline: return 15
            }
        }()
        
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: color,
            .strokeWidth: strokeWidth,
            .foregroundColor: color.withAlphaComponent({
                switch card.decoration {
                case .striped: return 0.20
                case .filled: return 1.0
                case .outline: return 0.0
                }
                }()
            )
        ]
        
        let cardTitle: String = {
            switch card.number {
            case .one: return cardSymbol
            case .two: return cardSymbol + " " + cardSymbol
            case .three: return cardSymbol + " " + cardSymbol + " " + cardSymbol
            }
        }()
        
        return NSAttributedString(string: cardTitle, attributes: attributes)
    }
}

