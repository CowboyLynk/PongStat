//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/29/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Variables
    let numCups = 10.0
    var numBase: Int!
    var madeCounter = 1
    var missedCounter = 1
    var cup = Cup()
    var cups = [Cup]()
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    
    // Actions
    @IBAction func missed(_ sender: Any) {
        missedButton.setTitle("MISSED: \(missedCounter)", for: .normal)
        missedCounter += 1
    }
    func normalTap(_ sender: UIGestureRecognizer){  // Made the cup
        print("Normal")
        removeCup(sender: sender)
        madeCounter += 1
    }
    func longTap(_ sender: UIGestureRecognizer){  // Someone else made the cup
        if sender.state == .began {
            print("Long")
            removeCup(sender: sender)
        }
    }
    
    // Functions
    func removeCup(sender: UIGestureRecognizer){
        let index = sender.view?.tag
        cup = cups[index!]
        cup.view.isUserInteractionEnabled = false
        cup.clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numBase = Int(-1/2*(1 - (8.0*numCups + 1.0).squareRoot()))
        
        // Adds cups and shadows
        let screenSize: CGRect = self.table.bounds
        var xValue = 0
        let yValue = 0
        let dimension = Int(Int(screenSize.width)/numBase)
        print(screenSize.width)
        for i in 0..<numBase {
            cup = Cup()
            cup.view.contentMode = UIViewContentMode.scaleAspectFit
            cup.view.frame = CGRect(x: xValue, y: yValue, width: dimension, height: dimension)
            cup.view.tag = i
            
            // Adds gestures
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_: )))
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_: )))
            cup.view.addGestureRecognizer(tapGesture)
            cup.view.addGestureRecognizer(longGesture)
            tapGesture.numberOfTapsRequired = 1
            
            self.table.addSubview(cup.view)
            cups.append(cup)
            xValue += dimension;
        }
        
        // Custon missed button appearance
        missedButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        missedButton.layer.shadowOpacity = 1
        missedButton.layer.shadowRadius = 0
        missedButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        missedButton.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}

