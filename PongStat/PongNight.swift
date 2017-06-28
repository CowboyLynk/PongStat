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
    
    func addGame(time: Date, score: Double){
        let last = pongNights.count
        pongNights[last - 1].append("\(formatTime.format(time: time))%\(score)")
        setDefaults()
    }
    
    func setDefaults(){
        let defaults = UserDefaults.standard
        defaults.set(pongNights, forKey: "PongNight")
    }
}
