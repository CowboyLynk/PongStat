//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/29/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    // Variables
    var numCups = 10.0
    var cup: Cup!
    var currentCup: Cup!
    var activeGame: PongGame!
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    
    // Actions
    @IBAction func undo(_ sender: Any) {
        if activeGame.turns.count > 0{
            let lastTurn = activeGame.turns.last
            let turnType = lastTurn?.0
            if turnType != "miss"{
                let cup = lastTurn?.1 as! Cup
                replaceCup(cup: cup)
                if turnType == "make"{
                    activeGame.madeCounter -= lastTurn?.2 as! Double
                }
            } else { // if its a miss
                activeGame.missedCounter -= 1
        }
        updateVisuals()
        activeGame.turns.removeLast()
        }
    }
    @IBAction func reset(_ sender: Any) {
        // Are you SUUUURE you want to reset
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            // Resets table
            self.clearTable()
            self.setTable()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Cup interactions
    @IBAction func missed(_ sender: Any) {  // User missed the cup
        activeGame.missedCounter += 1
        updateVisuals()
        activeGame.turns.append(("miss", false as AnyObject, 1 as AnyObject))
    }
    func normalTap(_ sender: UIGestureRecognizer){  // User made the cup
        setCurrentCup(sender: sender)
        removeCup(sender: sender)
        let multiplier = 1 + 0.1 * Double(5 - activeGame.calcCupsAround(cup: currentCup))
        activeGame.madeCounter += multiplier
        updateVisuals()
        activeGame.turns.append(("make", currentCup, multiplier as AnyObject))
    }
    func longTap(_ sender: UIGestureRecognizer){  // Someone else made the cup
        if sender.state == .began {
            setCurrentCup(sender: sender)
            removeCup(sender: sender)
            activeGame.turns.append(("remove", currentCup, false as AnyObject))
        }
    }
    
    // Functions
    func updateVisuals() {
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScore.text = activeGame.getScore()
    }
    func setCurrentCup(sender: UIGestureRecognizer){
        currentCup = activeGame.cupTags[(sender.view?.tag)!]
    }
    func removeCup(sender: UIGestureRecognizer){
        let location = currentCup.location
        activeGame.cupConfig[(location?.0)!][(location?.1)!] = false
        currentCup.view.isUserInteractionEnabled = false
        currentCup.clear()
    }
    func replaceCup(cup: Cup){
        let location = cup.location
        activeGame.cupConfig[(location?.0)!][(location?.1)!] = true
        cup.view.isUserInteractionEnabled = true
        cup.putBack()
    }
    func setTable(){
        let numBase = activeGame.numBase
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
                activeGame.cupTags.append(cup)
                activeGame.cupConfig[i][j] = true
                xValue += dimension;
                tagCounter += 1
            }
            yValue += Int(Double(dimension)*0.85)
        }
    }
    func clearTable(){
        activeGame = PongGame(cups: numCups)
        updateVisuals()
        for view in table.subviews{
            view.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set table
        activeGame = PongGame(cups: numCups)
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

