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
    var numCups: Int
    var numBase: Int
    var madeCounter: Double
    var missedCounter: Int
    var cupConfig: [[Bool]]
    var reRackConfig: [[Bool]]!
    var turns: [(String, AnyObject, Double, Int)]  // (type of shot, associated cup, multiplier, score)
    
    
    init(cups: Int){
        numCups = cups
        numBase = Int(-1/2*(1 - (8.0*Double(numCups) + 1.0).squareRoot()))
        madeCounter = 0.0
        missedCounter = 0
        cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        turns = []
    }
    
    func getScore() -> Int{
        var score = 0
        if madeCounter + Double(missedCounter) > 0.001{ // 0.001 to account for small errors with adding doubles
            score = Int(madeCounter/(madeCounter+Double(missedCounter))*100)
        }
        return score
    }
    
    func getNumNodes() -> Int{
        var counter = 0
        for turn in turns {
            if turn.0 != "remove"{
                counter += 1
            }
        }
        return counter
    }
    
    func getCupCount() -> Int{
        var counter = Int(numCups)
        for turn in turns{
            if turn.0 != "miss"{
                counter -= 1
            }
        }
        return counter
    }
    
    func calcCupsAround(cup: Cup) -> Int {
        var cupsAround = 0
        let maxIndex = cupConfig.count - 1
        let perms = [(1, 0), (1, 1), (0, 1), (0, -1), (-1, 0), (-1, -1)]
        let row = cup.location.0
        let col = cup.location.1
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

class CustomNav: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(red:0.20, green:0.41, blue:0.29, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}
