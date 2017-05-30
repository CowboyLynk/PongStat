//
//  Utils.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/30/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation

class PongGame {
    var cups: Array<Bool>
    var success: Double
    var total: Double
    var score: Double
    var nodes: Array<(Double, Int, Bool)>  // used to graph the scores over time
    
    var startTime: Double
    var endTime: Double
    
    init() {
        cups = Array(repeating: true, count: 10)
        success = 0
        total = 0
        score = 0
        nodes = [(Double, Int, Bool)]()
        
        startTime = Date().timeIntervalSinceReferenceDate
        endTime = -1
    }
    
    func getScoreAt(index i: Int) -> Double {
        return nodes[i].0
    }
    
    func madeCup(cup i: Int) -> Void {
        if !cups[i] {
            return
        }
        cups[i] = false
        let potentialCupsAround = PongGame.cupsAround(cup: i)
        var cupCount = 0
        for x in potentialCupsAround {
            if cups[x] {
                cupCount += 1
            }
        }
        let modifier = 1 + 0.1 * Double(5 - cupCount)
        success += modifier
        total += modifier
        updateGame(make: true)
    }
    
    func missedCup() {
        total += 1
        updateGame(make: false)
    }
    
    func updateGame(make: Bool) {
        score = success / total
        let time = 1 // This will be changed
        nodes.append((score, time, make))
    }
    
    func endGame() {
        endTime = Date().timeIntervalSinceReferenceDate
    }
    
    class func cupsAround(cup i: Int) -> Array<Int> {
        var cups = [Int]()
        switch i {
        case 0:
            cups = [1, 2]
        case 1:
            cups = [0, 2, 3, 4]
        case 2:
            cups = [0, 1, 4, 5]
        case 3:
            cups = [1, 4, 6, 7]
        case 4:
            cups = [1, 2, 3, 5, 7, 8]
        case 5:
            cups = [2, 4, 8, 9]
        case 6:
            cups = [3, 7]
        case 7:
            cups = [3, 4, 6, 8]
        case 8:
            cups = [4, 5, 7, 9]
        case 9:
            cups = [5, 8]
        default:
            break
        }
        return cups
    }
}

class Night {
    var games = [PongGame]()
    let startTime: Double
    
    init() {
        startTime = Date().timeIntervalSinceReferenceDate
    }
    
    func addGame(game: PongGame) {
        games.append(game)
    }
}
