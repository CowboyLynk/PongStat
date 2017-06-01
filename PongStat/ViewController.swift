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
    var numCups = 10.0
    var numBase: Int!
    var madeCounter = 0.0
    var missedCounter = 0
    var cup: Cup!
    var cupTags = [Cup]()
    var cupConfig = [[Bool]]()
    var cupsAround = 0
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    
    // Actions
    @IBAction func reset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            
            // Resets table
            self.clearTable()
            self.setTable()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func missed(_ sender: Any) {
        missedCounter += 1
        missedButton.setTitle("MISSED: \(missedCounter)", for: .normal)
        updateScore()
    }
    func normalTap(_ sender: UIGestureRecognizer){  // Made the cup
        print("Normal")
        removeCup(sender: sender)
        madeCounter += 1 + 0.1 * Double(5 - cupsAround)
        updateScore()
        
    }
    func longTap(_ sender: UIGestureRecognizer){  // Someone else made the cup
        if sender.state == .began {
            print("Long")
            removeCup(sender: sender)
        }
    }
    
    // Functions
    func removeCup(sender: UIGestureRecognizer){
        cup = cupTags[(sender.view?.tag)!]
        let location = cup.location
        cupConfig[(location?.0)!][(location?.1)!] = false
        cup.view.isUserInteractionEnabled = false
        cup.clear()
        cupsAround = calcCupsAround(cup: cup)
        print(cupConfig)
    }
    func setTable(){
        // Calculations
        numBase = Int(-1/2*(1 - (8.0*numCups + 1.0).squareRoot()))
        cupConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        
        // Adds cups and shadows
        let screenSize: CGRect = self.table.bounds
        var xValue = 0
        var yValue = 0
        let dimension = Int(Int(screenSize.width)/numBase)
        var tagCounter = 0
        for i in 0..<numBase {
            xValue = dimension*i/2
            for j in 0..<numBase-i {
                cup = Cup()
                cup.view.contentMode = UIViewContentMode.scaleAspectFit
                cup.view.frame = CGRect(x: xValue, y: yValue, width: dimension, height: dimension)
                cup.view.tag = tagCounter
                cup.location = (i, j)
                
                // Adds gestures
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_: )))
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_: )))
                cup.view.addGestureRecognizer(tapGesture)
                cup.view.addGestureRecognizer(longGesture)
                tapGesture.numberOfTapsRequired = 1
                
                self.table.addSubview(cup.view)
                cupTags.append(cup)
                cupConfig[i][j] = true
                xValue += dimension;
                tagCounter += 1
            }
            yValue += Int(Double(dimension)*0.85)
        }
    }
    func clearTable(){
        missedButton.setTitle("MISSED: \(missedCounter)", for: .normal)
        missedCounter = 0
        madeCounter = 0.0
        for view in table.subviews{
            view.removeFromSuperview()
        }
        cupTags.removeAll()
        updateScore()
    }
    func calcCupsAround(cup: Cup) -> Int {
        var cupsAround = 0
        let maxIndex = cupConfig.count - 1
        let perms = [(1, 0), (1, 1), (0, 1), (0, -1), (-1, 0), (-1, -1)]
        let row = cup.location.0
        let col = cup.location.1
        // check above
        for perm in perms{
            if row + perm.0 <= maxIndex && row + perm.0 >= 0 {
                if col + perm.1 <= maxIndex && col + perm.1 >= 0 {
                    let check = self.cupConfig[row + perm.0][col + perm.1]
                    if check == true {
                        cupsAround += 1
                    }
                }
            }
        }
        return cupsAround
    }
    func updateScore() {
        var score = 0
        if madeCounter + Double(missedCounter) != 0{
            score = Int(madeCounter/(madeCounter+Double(missedCounter))*100)
        }
        currentScore.text = "WEIGHTED SCORE: \(score)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table
        setTable()
        
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

