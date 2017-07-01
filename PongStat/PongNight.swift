//
//  PongNight.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/27/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

class PongNight {
    var pongNights = [[String]]()
    
    init(){
        let defaults = UserDefaults.standard
        if let defaultPongNights = defaults.array(forKey: "PongNight"){
            pongNights = defaultPongNights as! [[String]]
        }
        pongNights.append([])
    }
    
    func addGame(time: Date, score: Double, isWin: Bool){
        let last = pongNights.count
        pongNights[last - 1].append("\(staticFunctions.formatTime(time: time))%\(score)*\(isWin)")
        setDefaults()
    }
    
    func removeLastNight(){
        if (pongNights.last?.count)! > 0{
            pongNights.removeLast()
            pongNights.append([])
        }
    }
    
    func setDefaults(){
        let defaults = UserDefaults.standard
        defaults.set(pongNights, forKey: "PongNight")
    }
}
