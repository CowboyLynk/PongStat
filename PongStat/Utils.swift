//
//  Utils.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/22/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

// Classes
class reRackButton: UIButton{
    var tableArrangement: ([[Bool]], Int)!
    
    init(frame: CGRect, tableArrangement: ([[Bool]], Int)){
        self.tableArrangement = tableArrangement
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Extensions
extension UIView {
    
    func clearView(){ // Removes every subview from the view
        for subview in self.subviews{
            subview.removeFromSuperview()
        }
    }
    
    // Transform Functions
    func rotate(by: CGFloat){
        self.transform = transform.rotated(by: by)  // rotates the whole table
        for subview in self.subviews{  // reverse rotates each of the cups so that they are always upright
            subview.transform = subview.transform.rotated(by: -by)
        }
    }
    func setSize(){
        self.center = self.superview!.center
        self.transform = transform.scaledBy(x: 0.7, y: 0.7)
    }
    
    func copy(with zone: NSZone? = nil) -> UIView {
        let copy = UIView(frame: self.frame)
        //copy.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.bounds.width, height: self.bounds.height)
        copy.transform = self.transform
        var cup: Cup
        for cupSubview in self.subviews{
            cup = cupSubview as! Cup
            copy.addSubview(cup.makeCupCopy())
        }
        return copy
    }
}


