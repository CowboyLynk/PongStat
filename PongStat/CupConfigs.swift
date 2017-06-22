//
//  CupConfigs.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation


class CupConfigs {
    
    // returns a pyramid configuration with a specified base
    static func pyramid(numBase: Int) -> ([[Bool]], Int){
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
    
    static func stoplight() -> ([[Bool]], Int){
        return ([[true], [true], [true]], 2)
    }
    
    static func honeycomb() -> ([[Bool]], Int){
        return ([[false, true, true, false], [true, true, true, false], [true, true, false, false]], 0)
    }
}
