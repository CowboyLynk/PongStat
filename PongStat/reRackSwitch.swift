//
//  reRackSwitch.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/5/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class reRackSwitch: UIButton {
    // Variables
    var location = (Int(), Int())
    var switchState = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    // All start code goes here
    func initialize(){
        self.backgroundColor = UIColor.blue
    }
    
    func isPressed(){
        self.switchState = !self.switchState
        if switchState{
            self.backgroundColor = UIColor.red
        }
        else {
            self.backgroundColor = UIColor.blue
        }
        
    }

}
