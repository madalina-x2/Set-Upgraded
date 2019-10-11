//
//  IntExtensions.swift
//  Set-Game
//
//  Created by Madalina Sinca on 30/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

extension Int {
    var arc4random: Int {
        if self >= 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        return -Int(arc4random_uniform(UInt32(abs(self))))
    }
}

