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
    
    // Outlets
    @IBOutlet weak var made: UILabel!
    @IBOutlet weak var removed: UILabel!
    @IBOutlet weak var cup1: UIButton!
    
    // Actions
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

