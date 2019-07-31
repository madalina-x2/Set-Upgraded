//
//  ArrayExtensions.swift
//  Set-Game
//
//  Created by Madalina Sinca on 30/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for index in stride(from: count - 1, through: 1, by: -1) {
            let randomIndex = (index + 1).arc4random
            if index != randomIndex {
                self.swapAt(index, randomIndex)
            }
        }
    }
}

extension Array where Element == Card {
    func isSet() -> Bool {
        let number     = Set(self.map { $0.number } )
        let symbol     = Set(self.map { $0.symbol } )
        let decoration = Set(self.map { $0.decoration } )
        let color      = Set(self.map { $0.color } )
        
        return  number.count != 2 && symbol.count != 2 && decoration.count != 2 && color.count != 2
    }
}

extension Array where Element: Equatable {
    func getSetCards(_ closure: (_ check: [Element]) -> (Bool)) -> [Element] {
        for i in 0..<self.count  {
            for j in (i + 1)..<self.count {
                for k in (j + 1)..<self.count {
                    let result = [self[i],self[j],self[k]]
                    if closure(result) {
                        return result
                    }
                }
            }
        }
        return []
    }
}
