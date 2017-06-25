//
//  Animations.swift
//  PongStatUpdate
//
//  Created by Cowboy Lynk on 6/15/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit

class Animations: NSObject {
    static func springAnimateIn(viewToAnimate: UIView, blurView: UIVisualEffectView, view: UIView){
        // Sets initial scale
        viewToAnimate.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        
        // Adds BG blur
        view.addSubview(blurView)
        
        // Adds view to main screen
        view.addSubview(viewToAnimate)
        viewToAnimate.alpha = 0
        viewToAnimate.center = CGPoint.init(x: view.center.x, y: view.bounds.height)
        viewToAnimate.layer.shadowColor = UIColor.black.cgColor
        viewToAnimate.layer.shadowOpacity = 0.3
        viewToAnimate.layer.shadowOffset = CGSize.zero
        viewToAnimate.layer.shadowRadius = 20
        
        UIView.animate(withDuration: 0.4){
            viewToAnimate.alpha = 1
            blurView.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [] , animations: {
            viewToAnimate.center = CGPoint.init(x: view.center.x, y: view.bounds.height/2)
        }, completion: nil)
    }
    static func normalAnimateIn(viewToAnimate: UIView, blurView: UIVisualEffectView, view: UIView){
        // Sets initial scale and pos
        viewToAnimate.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        viewToAnimate.center = CGPoint.init(x: view.center.x, y: view.bounds.height/2)
        
        // Adds BG blur
        view.addSubview(blurView)
        
        // Adds view to main screen
        view.addSubview(viewToAnimate)
        viewToAnimate.alpha = 0
        viewToAnimate.layer.shadowColor = UIColor.black.cgColor
        viewToAnimate.layer.shadowOpacity = 0.3
        viewToAnimate.layer.shadowOffset = CGSize.zero
        viewToAnimate.layer.shadowRadius = 20
        
        UIView.animate(withDuration: 0.4){
            viewToAnimate.alpha = 1
            blurView.alpha = 1
        }
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [] , animations: {
            viewToAnimate.center = CGPoint.init(x: view.center.x, y: view.bounds.height/2)
            viewToAnimate.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }, completion: nil)
    }
    static func animateOut(viewToAnimate: UIView, blurView: UIVisualEffectView){
        UIView.animate(withDuration: 0.3, animations: {
            blurView.alpha = 0
            viewToAnimate.alpha = 0
            viewToAnimate.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            
        }) { (sucsess:Bool) in
            viewToAnimate.removeFromSuperview()
            blurView.removeFromSuperview()
        }
    }
}
