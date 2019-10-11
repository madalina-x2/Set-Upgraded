//
//  Card.swift
//  Concentration
//
//  Created by Madalina Sinca on 02/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct ConcentrationCard: Hashable {
    
    // MARK: - Private Properties
    
    private static var identifierFactory = 0;
    
    // MARK: - Public Properties
    
    var hashValue: Int {return identifier}
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    // MARK: - Init Methods
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }

    // MARK: - Methods
    
    private  static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

