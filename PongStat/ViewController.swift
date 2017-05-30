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
    var madeCounter = 1
    var missedCounter = 1
    var cup = UIImageView()
    var cups = [UIImageView]()
    let screenSize: CGRect = UIScreen.main.bounds
    
    // Outlets
    @IBOutlet weak var cup1: UIButton!
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
        cup.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Starts a game
        // let activeGame = PongGame()
        
        // Adds cups
        var xValue = 0
        for i in 0..<5 {
            cup = UIImageView(image: UIImage(named: "Cup")!)
            cup.isUserInteractionEnabled = true
            cup.contentMode = UIViewContentMode.scaleAspectFit
            cup.frame = CGRect(x: xValue, y: 100, width: 60, height: 60)
            cup.tag = i
            
            // Adds gestures
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_: )))
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_: )))
            cup.addGestureRecognizer(tapGesture)
            cup.addGestureRecognizer(longGesture)
            tapGesture.numberOfTapsRequired = 1
            
            self.table.addSubview(cup)
            cups.append(cup)
            xValue += Int(screenSize.width/5);
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

