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
    
    // Table arrangement: (Cup configuration, Grid type, number of 1/4 rotations)
    // Grid Type: 0: normal pyrmaid, 1: play button, 2: square grid, 3: other
    
    
    static func createButton(name: String, image: UIImage, tableArrangement: ([[Bool]], Int, Int)) -> reRackOption{
        let button = reRackOption(frame: CGRect(x: 0, y: 0, width: 125, height: 125), tableArrangement: tableArrangement, name: name)
        
        // Add image
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 40, 0)
        button.imageView?.layer.cornerRadius = 10
        
        // Add title
        button.setTitle(name.uppercased(), for: .normal)
        button.setTitleColor(UIColor(red:0.56, green:0.59, blue:0.62, alpha:1.0), for: .normal)
        button.titleLabel!.font =  UIFont(name: "HelveticaNeue-Bold", size: 14)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -300, -75, 0)
        
        // Other styling
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.1
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
    
    //2's
    static func pair() -> reRackOption {
        return createButton(name: "Pair", image: #imageLiteral(resourceName: "pair"), tableArrangement: ([[true], [true]], 2, 0))
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
    static func trapezoid() -> reRackOption{
        return createButton(name: "Trapezoid", image: #imageLiteral(resourceName: "square"), tableArrangement: ([[true, true, true], [true, true, false]], 0, 0))
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
        let button = createButton(name: "Wizard Staff", image:#imageLiteral(resourceName: "wizard"), tableArrangement: ([[true, false], [true, true], [true, false], [true, false]], 3, 0))
        button.newTableView = newView
        return button
    }
    static func house(width: CGFloat) -> reRackOption{
        let xCenter = width/2
        let cupDimension = CGFloat(100)
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        
        //Adds all the cups
        let cup4 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup4.center = CGPoint(x: xCenter, y: xCenter - cupDimension*0.88)
        cup4.location = (0, 0)
        let cup3 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup3.center = CGPoint(x: xCenter - cupDimension/2, y: xCenter)
        cup3.location = (1, 0)
        let cup2 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup2.center = CGPoint(x: xCenter + cupDimension/2, y: xCenter)
        cup2.location = (1, 1)
        let cup1 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup1.center = CGPoint(x: xCenter - cupDimension/2, y: xCenter + cupDimension)
        cup1.location = (2, 0)
        let cup0 = Cup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        cup0.center = CGPoint(x: xCenter + cupDimension/2, y: xCenter + cupDimension)
        cup0.location = (2, 1)
        
        newView.addSubview(cup4)
        newView.addSubview(cup3)
        newView.addSubview(cup2)
        newView.addSubview(cup1)
        newView.addSubview(cup0)
        let button = createButton(name: "House", image:#imageLiteral(resourceName: "House"), tableArrangement: ([[true, false], [true, true], [true, true]], 3, 0))
        button.newTableView = newView
        return button
    }
    
    //6's
    static func sixPack() -> reRackOption{
        return createButton(name: "Six Pack", image: #imageLiteral(resourceName: "sixpack"), tableArrangement: ([[true, true], [true, true], [true, true]], 2, 0))
    }
    static func  zipper() -> reRackOption{
        return createButton(name: "Zipper", image: #imageLiteral(resourceName: "zipper"), tableArrangement: ([[false, true, true, true], [true, true, true, false]], 3, 1))
    }
    
    //7's
    static func honeycomb() -> reRackOption{
        return createButton(name: "Honeycomb", image: #imageLiteral(resourceName: "honeycomb"), tableArrangement: ([[false, true, true, false], [true, true, true, false], [true, true, false, false]], 0, 0))
    }
    
    //8's
    static func marching() -> reRackOption{
        return createButton(name: "Marching", image: #imageLiteral(resourceName: "marching"), tableArrangement: ([[true, true], [true, true], [true,true], [true, true]], 2, 0))
    }
}
