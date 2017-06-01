//
//  Utils.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/1/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

class PongGame {
    var numCups: Double
    var numBase: Int
    var madeCounter: Double
    var missedCounter: Int
    var cupTags: [Cup]
    var cupConfig: [[Bool]]
    
    
    init(cups: Double){
        numCups = cups
        numBase = Int(-1/2*(1 - (8.0*numCups + 1.0).squareRoot()))
        madeCounter = 0.0
        missedCounter = 0
        cupTags = [Cup]()
        cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
    }
    
    func getScore() -> String {
        var score = 0
        if madeCounter + Double(missedCounter) != 0{
            score = Int(madeCounter/(madeCounter+Double(missedCounter))*100)
        }
        return "WEIGHTED SCORE: \(score)"
    }
    
    func calcCupsAround(cup: Cup) -> Int {
        var cupsAround = 0
        let maxIndex = cupConfig.count - 1
        let perms = [(1, 0), (1, 1), (0, 1), (0, -1), (-1, 0), (-1, -1)]
        let row = cup.location.0
        let col = cup.location.1
        // check above
        for perm in perms{
            if row + perm.0 <= maxIndex && row + perm.0 >= 0 {
                if col + perm.1 <= maxIndex && col + perm.1 >= 0 {
                    let check = self.cupConfig[row + perm.0][col + perm.1]
                    if check == true {
                        cupsAround += 1
                    }
                }
            }
        }
        return cupsAround
    }
}
