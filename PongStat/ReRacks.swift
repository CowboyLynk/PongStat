//
//  CupConfigs.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit


class ReRacks {
    
    static func createButton(name: String, image: UIImage){
        //let button = reRackButtton()
    }

    static func pyramid(numBase: Int) -> ([[Bool]], Int){
        //CREATE BUTTON HERE!!!
        var cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        
        var colShrinker = 0
        for row in 0..<cupConfig.count{
            for col in 0..<(cupConfig[0].count - colShrinker){
                cupConfig[row][col] = true
            }
            colShrinker += 1
        }
        
        return (cupConfig, 0)
    }
    
    //3's
    static func stoplight() -> ([[Bool]], Int){
        return ([[true], [true], [true]], 2)
    }
    static func thinRedLine() -> ([[Bool]], Int){
        return ([[true, true, true]], 2)
    }
    
    //4's
    static func diamond() -> ([[Bool]], Int){
        return ([[false, true, false], [true, true, false], [true, false, false]], 0)
    }
    static func square() -> ([[Bool]], Int){
        return ([[true, true], [true, true], [true, true]], 2)
    }
    
    //5's
    static func trapezoid() -> ([[Bool]], Int){
        return ([[true, true, true], [true, true, false]], 0)
    }
    
    //6's
    static func sixPack() -> ([[Bool]], Int){
        return ([[true, true], [true, true], [true, true]], 2)
    }
    
    //7's
    static func honeycomb() -> ([[Bool]], Int){
        return ([[false, true, true, false], [true, true, true, false], [true, true, false, false]], 0)
    }
    
    //8's
    static func marching() -> ([[Bool]], Int){
        return ([[true, true], [true, true], [true,true], [true, true]], 2)
    }
}
