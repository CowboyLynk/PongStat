//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/29/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

// Make class name more Discriptive
class PongGameVC: UIViewController {
    // Variables
    var numCups = 10 // This should be an Int, not a double
    var activeGame: PongGame!
    var cup: Cup!
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    
    // Actions
    @IBAction func undo(_ sender: Any) {
        // this is messy, don't force unwrap the optionals
        if activeGame.turns.count > 0 {
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

    // this needs a better name (resetButtonTapped)
    @IBAction func reset(_ sender: Any) {
        // Actions should be on the right side, cancel should be on left
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            // Resets table
            self.clearTable()
            self.setTable()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    // Cup interactions
    @IBAction func missed(_ sender: Any) {  // User missed the cup
        activeGame.missedCounter += 1
        updateVisuals()
        activeGame.turns.append(("miss", false as AnyObject, 1 as AnyObject))
    }


    // Functions
    func updateVisuals() {
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScore.text = activeGame.getScore()
    }

    func replaceCup(cup: Cup){
        let location = cup.location
        activeGame.cupConfig[(location.0)][(location.1)] = true
        cup.isUserInteractionEnabled = true
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

                cup = Cup(frame: CGRect(x: xValue, y: yValue, width: dimension, height: dimension))
                cup.tag = tagCounter
                cup.location = (i, j)
                cup.delegate = self
                
                self.table.addSubview(cup)
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

    // this should be set in the pList
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func removeCup(cup: Cup) {
        let location = cup.location
        activeGame.cupConfig[(location.0)][(location.1)] = false
        cup.isUserInteractionEnabled = false
        cup.clear()
    }

}

// When dealing with protocols, it's best practice to put them in an extension
extension PongGameVC: CupDelegate {
    func didTap(cup: Cup) {

        removeCup(cup: cup)


        let multiplier = 1 + 0.1 * Double(5 - activeGame.calcCupsAround(cup: cup))
        activeGame.madeCounter += multiplier
        updateVisuals()
        activeGame.turns.append(("make", cup, multiplier as AnyObject))
    }

    func didLongTap(cup: Cup, longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began {

            removeCup(cup: cup)

            activeGame.turns.append(("remove", cup, false as AnyObject))
        }
    }
}


