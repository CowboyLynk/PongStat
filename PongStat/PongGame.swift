//
//  PongGame.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

class PongGame: NSObject, NSCopying {
    var score: Double
    var madeCounter: Double
    var missedCounter: Int
    var cupConfig: [[Bool]]!
    var tableType: Int!
    
    override init(){
        madeCounter = 0
        missedCounter = 0
        score = 0
    }
    
    func updateScore(){
        if madeCounter + Double(missedCounter) > 0 {
            score = madeCounter/(madeCounter+Double(missedCounter))*100
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PongGame()
        copy.score = self.score
        copy.madeCounter = self.madeCounter
        copy.missedCounter = self.missedCounter
        copy.cupConfig = self.cupConfig
        copy.tableType = self.tableType
        return copy
    }
    
    // Auxillary Funcions
    func getLargestRowCount(cupConfig: [[Bool]]) -> Int{  // Used to calculate the cup height and width
        // More info: use the cups because the number of cups matter more than the legth of the array its in. See honeycomb example: it onyl has 3 cups, but an array row length of 4
        var largestRowCount = 0
        for row in cupConfig{
            var count = 0
            for cup in row{
                if cup {
                    count += 1
                }
            }
            if count > largestRowCount{
                largestRowCount = count
            }
        }
        return largestRowCount
    }
}
