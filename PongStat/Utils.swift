//
//  Utils.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/22/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

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
        let scaleFactor = self.superview!.bounds.width/self.bounds.width * 0.7
        //self.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        self.center = self.superview!.center
        self.transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
    }
}


