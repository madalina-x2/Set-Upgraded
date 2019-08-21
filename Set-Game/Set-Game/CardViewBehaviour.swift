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
            static let dealTime = 0.0
            static let rearrangeTime = 0.0
            static let flipOverTime = 0.0
            static let snapWhenMatchedTime = 0.0
        }
        struct Delays {
            static let rearrange = 0.0
        }
    }
    
    // MARK: - Overridden Methods
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    // MARK - Behaviours
    
    private lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior()
        behaviour.translatesReferenceBoundsIntoBoundary = true
        return behaviour
    }()
    
    private lazy var basicPropertyBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior()
        behaviour.allowsRotation = true
        behaviour.elasticity = 1.2
        behaviour.resistance = 0
        return behaviour
    }()
    
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
}
