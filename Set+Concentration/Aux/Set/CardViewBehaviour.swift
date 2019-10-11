//
//  CardViewBehaviour.swift
//  Set-Game
//
//  Created by Madalina Sinca on 21/08/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class CardViewBehaviour: UIDynamicBehavior {
    
    // MARK: - Constants
    
    private struct Constants {
        struct Durations {
            static let dealTime = 0.1
            static let hintTime = 1.0
            static let shuffleTime = 1.0
            static let rearrangeTime = 0.1
            static let flipOverTime = 0.5
            static let snapWhenMatchedTime = 0.3
            static let selectionDuration = 0.1
        }
        struct Delays {
            static let none = 0.0
            static let rearrange = 0.1
            static let snap = 0.6
        }
    }
    
    // MARK: - Properties
    
    private var snapBehaviors: [UISnapBehavior: CardView] = [:]
    
    private lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior()
        behaviour.translatesReferenceBoundsIntoBoundary = true
        return behaviour
    }()
    
    private lazy var basicPropertyBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior()
        behaviour.allowsRotation = true
        behaviour.elasticity = 1.0
        behaviour.resistance = 0
        return behaviour
    }()
    
    // MARK: - Overridden Methods
    
    override init() {
        super.init()
        addChildBehavior(collisionBehaviour)
        addChildBehavior(basicPropertyBehaviour)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    // MARK: Animations
    
    func flipOver(_ cardView: CardView) -> ((UIViewAnimatingPosition) -> Void) {
        return { if $0 == .end {
            UIView.transition(
                with: cardView,
                duration: Constants.Durations.flipOverTime,
                options: [.transitionFlipFromLeft],
                animations: { cardView.isFaceUp = !cardView.isFaceUp },
                completion: nil
            )
        }}
    }
    
    func snapTo(retreatingPoint: CGRect, cardView: CardView) {
        collisionBehaviour.removeItem(cardView)
        
        let snap = UISnapBehavior(item: cardView, snapTo: retreatingPoint.origin)
        snap.damping = 1.5
        addChildBehavior(snap)
        snapBehaviors[snap] = cardView
    
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Constants.Durations.snapWhenMatchedTime,
            delay: Constants.Delays.snap,
            options: [],
            animations: {
                cardView.isFaceUp = false
                cardView.bounds.size = retreatingPoint.size
                cardView.reconfigureShadow()
        },
            completion: { _ in
                cardView.alpha = 0.0
                cardView.removeFromSuperview()
            }
            )
    }
    
    func spin360(_ cardView: CardView, duration: TimeInterval, delay: TimeInterval) {        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: delay,
            options: [],
            animations: { cardView.transform = cardView.transform.rotated(by: CGFloat.pi) },
            completion: nil
        )
    }
    
    func animateFromSpawningPoint(cardDeckView: CardDeckView, cardViews: [CardView], delay: TimeInterval, index: Int) {
        let duration = Constants.Durations.dealTime
        var delay = delay
        var index = index
        
        for cardView in cardViews {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: duration,
                delay: delay,
                options: [],
                animations: {
                    cardView.center = cardDeckView.grid[index]!.getCenter()
                    cardView.bounds.size = cardDeckView.grid[index]!.size
                    cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                    cardView.alpha = 1.0
            },
                completion: self.flipOver(cardView)
            )
            delay += 0.4
            index += 1
        }
    }
    
    func animateFromSpawningPointToIndex(cardDeckView: CardDeckView, cardView: CardView, delay: TimeInterval, index: Int) {
        let duration = Constants.Durations.dealTime
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: delay,
            options: [],
            animations: {
                cardView.center = cardDeckView.grid[index]!.getCenter()
                cardView.bounds.size = cardDeckView.grid[index]!.size
                cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                cardView.alpha = 1.0
        },
            completion: self.flipOver(cardView)
        )
    }
    
    func animateHint(cardViews: [CardView]) {
        let duration = Constants.Durations.hintTime
        
        for cardView in cardViews {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: duration,
                delay: Constants.Delays.none,
                options: [],
                animations: {
                    cardView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            },
                completion: { _ in
                    for cardView in cardViews {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: duration,
                            delay: Constants.Delays.none,
                            options: [],
                            animations: {
                                cardView.changeBackgroundColor()
                                cardView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        },
                            completion: nil
                        )
                    }
                }
            )
        }
    }
    
    func animateSelection(cardView: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Constants.Durations.selectionDuration,
            delay: Constants.Delays.none,
            options: [],
            animations: {
                cardView.changeBackgroundColor()
        },
            completion: nil
        )
    }
    
    func dealCards(in cardDeckView: CardDeckView, cardsToReconfig: [CardView], cardsToSpawn: [CardView], delay: TimeInterval) {
        self.animateGridReconfig(in: cardDeckView, cardsToAnimate: cardsToReconfig, delay: delay)
        let delay = Constants.Durations.rearrangeTime
        self.animateFromSpawningPoint(cardDeckView: cardDeckView, cardViews: cardsToSpawn, delay: delay, index: cardsToReconfig.count)
    }
    
    func animateNewCards(in cardDeckView: CardDeckView, cardsToAnimate: [CardView], delay: TimeInterval) -> ((UIViewAnimatingPosition) -> Void) {
        return { if $0 == .end {
            let duration = Constants.Durations.dealTime
            var delay = delay
            var index = 0
            
            for cardView in cardsToAnimate {
                self.spin360(cardView, duration: duration / 2, delay: delay)
                self.spin360(cardView, duration: duration / 2, delay: delay + duration / 2)
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: delay,
                    options: [],
                    animations: {
                        cardView.center = cardDeckView.grid[index]!.getCenter()
                        cardView.bounds.size = cardDeckView.grid[index]!.size
                        cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                        cardView.alpha = 1.0
                },
                    completion: self.flipOver(cardView)
                )
                delay += 0.2
                index += 1
            }
            }}
    }
    
    func animateGridReconfig(in cardDeckView: CardDeckView, cardsToAnimate: [CardView], delay: TimeInterval) {
        let duration = Constants.Durations.rearrangeTime
        var delay = delay
        var index = 0
        
        for cardView in cardsToAnimate {
            let equalVal = cardsToAnimate[0].bounds.size == cardDeckView.grid[index]!.size
            if equalVal == false {
                self.spin360(cardView, duration: duration / 2, delay: delay)
                self.spin360(cardView, duration: duration / 2, delay: delay + duration / 2)
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: delay,
                    options: [],
                    animations: {
                        cardView.center = cardDeckView.grid[index]!.getCenter()
                        cardView.bounds.size = cardDeckView.grid[index]!.size
                        cardView.reconfigureShadow()
                        cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                        cardView.alpha = 1.0
                },
                    completion: nil
                )
                delay += 0.15
                index += 1
            }
        }
    }
    
    func animateShuffle(cardViews: [CardView], superview: CardDeckView) {
        let duration = Constants.Durations.shuffleTime
        var delay = Constants.Delays.none
        
        for cardView in cardViews {
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: duration,
                delay: delay,
                options: [],
                animations: {
                    cardView.center = superview.grid[cardView.tag]!.getCenter()
                    cardView.bounds.size = superview.grid[cardView.tag]!.size
                    cardView.reconfigureShadow()
                    cardView.frame = cardView.frame.insetBy(dx: 5, dy: 5)
                    cardView.alpha = 1.0
            },
                completion: nil
            )
            delay += 0.15
        }
    }
    
    // MARK: - Auxiliary Methods
    
    func removeCardView(_ cardView: CardView) {
        basicPropertyBehaviour.removeItem(cardView)
        collisionBehaviour.removeItem(cardView)
        snapBehaviors.keys.forEach { snap in
            if snapBehaviors[snap] == cardView {
                snapBehaviors.removeValue(forKey: snap)
                removeChildBehavior(snap)
            }
        }
    }
}

