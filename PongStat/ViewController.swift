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
    var removedCounter = 1
    var missedCounter = 1
    
    // Outlets
    @IBOutlet weak var made: UILabel!
    @IBOutlet weak var removed: UILabel!
    @IBOutlet weak var cup1: UIButton!
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    
    
    //Actions
    @IBAction func missed(_ sender: Any) {
        missedButton.setTitle("MISSED: \(missedCounter)", for: .normal)
        missedCounter += 1
    }
    
    func normalTap(_ sender: UIGestureRecognizer){
        made.text = String(madeCounter)
        madeCounter += 1
    }
    
    func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            removed.text = String(removedCounter)
            removedCounter += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Custon missed button appearance
        missedButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        missedButton.layer.shadowOpacity = 1
        missedButton.layer.shadowRadius = 0
        missedButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        missedButton.layer.cornerRadius = 15
        
        // Adds tap gestures to buttons
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        cup1.addGestureRecognizer(tapGesture)
        cup1.addGestureRecognizer(longGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

