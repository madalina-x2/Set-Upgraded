//
//  ViewController.swift
//  Set-Game
//
//  Created by Madalina Sinca on 15/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game = Game()
    private var playAgainstIos = false
    private var iosWonRound = false
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    @IBOutlet weak private var setCountLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var deckCountLabel: UILabel!
    @IBOutlet weak private var setInformLabel: UILabel!
    @IBOutlet weak private var iosLabel: UILabel!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateViewFromModel()
    }
    
    @objc func iosEnterRound() {
        print("did enter iOS turn")
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
        print("iOS make set")
        game.cardsSelected.removeAll()
        game.cardsSelected = game.cardsHint
        updateViewFromModel()
        game.isSet = game.isSet
        waitForFunc(duration: 2.0, selector: #selector(self.iosExitRound))
    }
    
    @objc func iosExitRound() {
        print("ios Exist round")
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
    
    var timer: Timer?
    func waitForFunc(duration: TimeInterval, selector: Selector) {
        timer?.invalidate()
        print("will wait for \(duration)")
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: selector, userInfo:nil, repeats: false)
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
        } else { print("chosen card was not in cardButtons") }
    }
    
    @IBOutlet weak private var dealCardsButton: UIButton!
    
    @objc func clearLabel() {
        setInformLabel.text = ""
        setInformLabel.alpha = 0.0
    }
    
    @objc func clearColor(for button: UIButton) {
        button.layer.backgroundColor = #colorLiteral(red: 0.9096221924, green: 0.9060236216, blue: 0.8274506927, alpha: 1)
    }
    
    @IBAction private func dealCards(_ sender: UIButton) {
        game.dealThreeCards()
        updateViewFromModel()
    }
    
    @IBAction func giveHint(_ sender: UIButton) {
        game.giveHint()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        deckCountLabel.text = "DECK: \(game.deckCount)"
        scoreLabel.text = "SCORE: \(game.score)"
        setCountLabel.text = "SETS: \(game.cardsSets.count)"
        if game.cardsSelected.count == 3 {
            if self.game.isSet == true {
                self.setInformLabel.text = "✅"
                self.setInformLabel.textColor = .green
                if playAgainstIos, !iosWonRound {
                    print("a set was made")
                    waitForFunc(duration: 10, selector: #selector(self.iosTurn))
                    iosLabel.text = "iOS: 😢"
                }
            } else {
                self.setInformLabel.text = "𝗫"
                self.setInformLabel.textColor = .red
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.setInformLabel.alpha = 1.0
            }) { (_) in
                self.perform(#selector(self.clearLabel), with: nil, afterDelay: 2)
            }
        }
        
        if game.cardsOnTable.count < 27, game.deckCount > 0 {
            dealCardsButton.isEnabled = true
        } else { dealCardsButton.isEnabled = false }
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < game.cardsOnTable.count {
                let card: Card? = game.cardsOnTable[index]
                
                if let card = card, game.cardsOnTable.contains(card) {
                    button.setAttributedTitle(attributedStringForCard(game.cardsOnTable[index]), for: .normal)
                    button.isEnabled = true
                    button.isHidden = false
                    if game.cardsHint.contains(card){
                        button.layer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.9558855858, blue: 0.7371077641, alpha: 1)
                    } else if game.cardsSelected.count == 3, game.cardsSelected.contains(card) {
                        if self.game.isSet == true {
                            button.layer.backgroundColor = #colorLiteral(red: 0.7741263415, green: 0.8862745166, blue: 0.6670993155, alpha: 1)
                        } else {
                            UIView.animate(withDuration: 0.3, animations: {
                                button.layer.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                            }) { (_) in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                    if (self.game.cardsSelected.contains(card)){
                                        button.layer.backgroundColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
                                    } else {
                                        button.layer.backgroundColor = #colorLiteral(red: 0.9096221924, green: 0.9060236216, blue: 0.8274506927, alpha: 1)
                                    }
                                })
                            }
                        }
                    } else if game.cardsSelected.contains(card) {
                        button.layer.backgroundColor = #colorLiteral(red: 0.8037576079, green: 0.788402617, blue: 0.6902456284, alpha: 1)
                    } else {
                         button.layer.backgroundColor = #colorLiteral(red: 0.9096221924, green: 0.9060236216, blue: 0.8274506927, alpha: 1)
                    }
                    button.layer.cornerRadius = 8.0
                }
            } else {
                button.isHidden = true
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            }
        }
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

