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
    var reRackConfig: [[Bool]]!
    var reRackGridType: Int!
    var tableView: UIView!
    var turnType = 4 //0: user made, 1: user missed, 2: partner made, 3: reRack
    
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
    
    func getPossibleReRacks() -> [Any]{
        let numCups = self.getCount(array: self.cupConfig)
        var possibleReRacks = [reRackOption]()
        if numCups > 1{
            let numBase = -1/2*(1 - (8.0*Double(numCups) + 1.0).squareRoot())
            if numBase.truncatingRemainder(dividingBy: 1.0) == 0{
                possibleReRacks.append(ReRacks.pyramid(numBase: Int(numBase)))
                possibleReRacks.append(ReRacks.playButton(numBase: Int(numBase)))
            }
        }
        
        switch numCups{
        case 2:
            possibleReRacks.append(ReRacks.pair())
        case 3:
            possibleReRacks.append(contentsOf: [ReRacks.stoplight(), ReRacks.thinRedLine()])
        case 4:
            possibleReRacks.append(contentsOf: [ReRacks.diamond(), ReRacks.square(), ReRacks.penis(width: self.tableView.bounds.width)])
        case 5:
            possibleReRacks.append(contentsOf: [ReRacks.wizard(width: self.tableView.bounds.width), ReRacks.house(width: self.tableView.bounds.width)])
        case 6:
            possibleReRacks.append(contentsOf: [ReRacks.sixPack(), ReRacks.zipper()])
        case 7:
            possibleReRacks.append(ReRacks.honeycomb())
        case 8:
            possibleReRacks.append(ReRacks.marching())
        default: break
        }
        possibleReRacks.append(ReRacks.createButton(name: "Custom", image: #imageLiteral(resourceName: "customTriangle"), tableArrangement: ([], 0, 0)))
        possibleReRacks.append(ReRacks.createButton(name: "Custom", image: #imageLiteral(resourceName: "customGrid"), tableArrangement: ([], 2, 0)))
        return possibleReRacks
    }
    
    func getCupsAround(forCup: Cup) -> Int{
        var counter = 0
        
        let desiredDistance = forCup.bounds.width*1.5
        for subview in tableView.subviews {
            let cupAround = subview as! Cup
            let distance = ((cupAround.center.x - forCup.center.x) * (cupAround.center.x - forCup.center.x) + (cupAround.center.y - forCup.center.y) * (cupAround.center.y - forCup.center.y)).squareRoot()
            if distance <= desiredDistance && distance != 0{
                if cupAround.cup.isHidden == false{
                    counter += 1
                }
            }
        }
        return counter
    }
    
    func getCount(array: [[Bool]]) -> Int{
        var count = 0
        for row in 0..<array.count{
            for col in 0..<array[0].count{
                if array[row][col]{
                    count += 1
                }
            }
        }
        return count
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PongGame()
        copy.score = self.score
        copy.madeCounter = self.madeCounter
        copy.missedCounter = self.missedCounter
        copy.cupConfig = self.cupConfig
        copy.tableView = self.tableView.copy()
        copy.turnType = self.turnType
        return copy
    }
    
    // Auxillary Funcions
    func getLargestRowCount(cupConfig: [[Bool]]) -> Int{  // Used to calculate the cup height and width
        // More info: uses the number of cups because the number of cups matters more than the length of the array it's in. See honeycomb example: it only has 3 cups, but an array row length of 4
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
    func removeEmptyEdges(){ // removes redundant rows and edges. Used when setting custom reracks
        var colsToRemove: [Int] = []
        var rowsToRemove: [Int] = []
        var reverseColsToRemove: [Int] = []
        var reverseRowsToRemove: [Int] = []
        
        // finds empty columns
        for col in 0..<cupConfig[0].count{
            var foundCup = false
            for row in 0..<cupConfig.count{
                if cupConfig[row][col]{
                    foundCup = true
                    break
                }
            }
            if foundCup != true{
                colsToRemove.append(col)
            } else {
                break
            }
        }
        for col in 0..<cupConfig[0].count{
            var foundCup = false
            for row in 0..<cupConfig.count{
                if cupConfig[row][cupConfig.count - 1 - col]{
                    foundCup = true
                    break
                }
            }
            if foundCup != true{
                reverseColsToRemove.append(cupConfig.count - 1 - col)
            } else {
                break
            }
        }
        
        // finds empty rows
        for row in 0..<cupConfig.count {
            var foundCup = false
            for item in cupConfig[row]{
                if item {
                    foundCup = true
                    break
                }
            }
            if foundCup != true {
                rowsToRemove.append(row)
            } else {
                break
            }
        }
        for row in 0..<cupConfig.count {
            var foundCup = false
            for item in cupConfig[cupConfig.count - 1 - row]{
                if item {
                    foundCup = true
                    break
                }
            }
            if foundCup != true {
                reverseRowsToRemove.append(cupConfig.count - 1 - row)
            } else {
                break
            }
        }
        
        print(rowsToRemove)
        print(colsToRemove)
        print(reverseRowsToRemove)
        print(reverseColsToRemove)
        print()
        
        var reverseColCounter = 0
        var reverseRowCounter = 0
        
        // removes empty rows and cols
        var counter = 0
        for colIndex in colsToRemove{
            removeCol(index: colIndex - counter)
            counter += 1
            reverseColCounter += 1
        }
        counter = 0
        for rowIndex in rowsToRemove{
            cupConfig.remove(at: rowIndex - counter)
            counter += 1
            reverseRowCounter += 1
        }
        
        // removes empty rows and cols from reverse side
        for colIndex in reverseColsToRemove{
            removeCol(index: colIndex - reverseColCounter)
        }
        for rowIndex in reverseRowsToRemove{
            cupConfig.remove(at: rowIndex - reverseRowCounter)
        }
        
    }
    func removeCol(index: Int){
        for row in 0..<cupConfig.count{
            cupConfig[row].remove(at: index)
        }
    }
}
