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
    
    //Table arrangement: (Cup configuration, Grid type, number of 1/4 rotations)
    static func createButton(name: String, image: UIImage, tableArrangement: ([[Bool]], Int, Int)) -> reRackOption{
        let button = reRackOption(frame: CGRect(x: 0, y: 0, width: 125, height: 125), tableArrangement: tableArrangement, name: name)
        
        // Add image
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 0)
        button.imageView?.layer.cornerRadius = 10
        
        // Add title
        button.setTitle(name, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -300, -95, 0)
        
        // Other styling
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }

    static func pyramid(numBase: Int) -> reRackOption{
        var cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        
        var colShrinker = 0
        for row in 0..<cupConfig.count{
            for col in 0..<(cupConfig[0].count - colShrinker){
                cupConfig[row][col] = true
            }
            colShrinker += 1
        }
        
        return createButton(name: "Pyramid", image: #imageLiteral(resourceName: "pyramid"), tableArrangement: (cupConfig, 0, 0))
    }
    
    static func playButton(numBase: Int) -> reRackOption{
        var cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        
        var colShrinker = 0
        for row in 0..<cupConfig.count{
            for col in 0..<(cupConfig[0].count - colShrinker){
                cupConfig[row][col] = true
            }
            colShrinker += 1
        }
        
        return createButton(name: "Play Button", image: #imageLiteral(resourceName: "playbutton"), tableArrangement: (cupConfig, 1, 1))
    }
    
    //3's
    static func stoplight() -> reRackOption{
        return createButton(name: "Stop Light", image: #imageLiteral(resourceName: "stoplight"), tableArrangement: ([[true], [true], [true]], 2, 0))
    }
    static func thinRedLine() -> reRackOption{
        return createButton(name: "Thin Line", image: #imageLiteral(resourceName: "thinline"), tableArrangement: ([[true], [true], [true]], 2, 1))
    }
    
    //4's
    static func diamond() -> reRackOption{
        return createButton(name: "Diamond", image: #imageLiteral(resourceName: "diamond"), tableArrangement: ([[false, true, false], [true, true, false], [true, false, false]], 0, 0))
    }
    static func square() -> reRackOption{
        return createButton(name: "Square", image: #imageLiteral(resourceName: "square"), tableArrangement: ([[true, true], [true, true]], 2, 0))
    }
    static func penis(width: CGFloat) -> reRackOption{
        let xCenter = width/2
        let cupDimension = CGFloat(100)
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        
        //Adds all the cups
        let cup3 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup3.center = CGPoint(x: xCenter - cupDimension/2, y: xCenter - cupDimension*0.88)
        cup3.location = (0, 0)
        let cup2 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup2.center = CGPoint(x: xCenter + cupDimension/2, y: xCenter - cupDimension*0.88)
        cup2.location = (0, 1)
        let cup1 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup1.center = CGPoint(x: xCenter, y: xCenter)
        cup1.location = (1, 0)
        let cup0 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup0.center = CGPoint(x: xCenter, y: xCenter + cupDimension)
        cup0.location = (2, 0)
        
        newView.addSubview(cup3)
        newView.addSubview(cup2)
        newView.addSubview(cup1)
        newView.addSubview(cup0)
        let button = createButton(name: "2-1-1", image: #imageLiteral(resourceName: "penis"), tableArrangement: ([[true, true], [true, false], [true, false]], 3, 0))
        button.newTableView = newView
        return button
    }
    
    //5's
    static func trapezoid() -> ([[Bool]], Int){
        return ([[true, true, true], [true, true, false]], 0)
    }
    static func wizard(width: CGFloat) -> reRackOption{
        let xCenter = width/2
        let cupDimension = CGFloat(100)
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        
        //Adds all the cups
        let cup4 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup4.center = CGPoint(x: xCenter, y: xCenter - cupDimension/2 - cupDimension*0.88)
        cup4.location = (0, 0)
        let cup3 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup3.center = CGPoint(x: xCenter - cupDimension/2, y: xCenter - cupDimension*0.88/2)
        cup3.location = (1, 0)
        let cup2 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup2.center = CGPoint(x: xCenter + cupDimension/2, y: xCenter - cupDimension*0.88/2)
        cup2.location = (1, 1)
        let cup1 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup1.center = CGPoint(x: xCenter, y: xCenter + cupDimension*0.88/2)
        cup1.location = (2, 0)
        let cup0 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup0.center = CGPoint(x: xCenter, y: xCenter + 1.5*cupDimension)
        cup0.location = (3, 0)
        
        newView.addSubview(cup4)
        newView.addSubview(cup3)
        newView.addSubview(cup2)
        newView.addSubview(cup1)
        newView.addSubview(cup0)
        let button = createButton(name: "Wizard Staff", image: #imageLiteral(resourceName: "penis"), tableArrangement: ([[true, false], [true, true], [true, false], [true, false]], 3, 0))
        button.newTableView = newView
        return button
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
