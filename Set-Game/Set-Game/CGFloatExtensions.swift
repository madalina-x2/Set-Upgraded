//
//  CGFloatExtensions.swift
//  Set-Game
//
//  Created by Madalina Sinca on 22/08/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var arc4random: CGFloat {
        if self >= 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        }
        return -CGFloat(arc4random_uniform(UInt32(abs(self))))
    }
}
