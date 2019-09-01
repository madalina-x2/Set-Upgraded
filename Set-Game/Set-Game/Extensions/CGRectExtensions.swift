//
//  CGRectExtensions.swift
//  Set-Game
//
//  Created by Madalina Sinca on 22/08/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    func getCenterOf() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
