//
//  PongGameVC.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit

class PongGameVC: UIViewController {
    // Variables
    var activeGame: PongGame!
    var tableView: UIView!
    var turns = [PongGame]()
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!

    // Actions
    @IBAction func rotateButtonTapped(_ sender: Any) {
        tableView.rotate(by: CGFloat.pi/2)
    }
    @IBAction func undoButtonTapped(_ sender: Any) {
        if turns.count > 1{
            tableView.clearView()
            turns.removeLast()
            activeGame = turns.last?.copy() as! PongGame
            
            // Adds all the cups from the SAVED tableView to the ACTIVE tableView
            for subview in activeGame.tableView.subviews{
                let cup = subview as! Cup
                tableView.addSubview(cup.makeCupCopy())
            }
            tableView.transform = activeGame.tableView.transform // makes sure the ACTIVE tableView is in the same orientation as the SAVED tableView
            
            // sets the now updated tableView to be the one that updates in the game
            activeGame.tableView = tableView
            
            updateVisuals()
            //checkForReReck()
        }
    }
    @IBAction func reRackButtonTapped(_ sender: Any) {
    }
    
    // Functions
    func takeTurn(turnType: Int, playedCup: Any) {
        switch turnType{  // the switch is used for shared
        case 1:  // User missed the cup
            activeGame.missedCounter += 1
        case 0, 2:  // Made by user or someone else
            let playedCup = playedCup as! Cup
            playedCup.removeCup()
            activeGame.cupConfig[playedCup.location.0][playedCup.location.1] = false
            if turnType == 0{ // Made by user
                //let multiplier = 1 + 0.1 * Double(6 - activeGame.calcCupsAround(cup: playedCup))
                let multiplier = 1.0
                activeGame.madeCounter += multiplier
            }
            //checkForReReck()
        default:
            print("default")
        }
        activeGame.updateScore()
        turns.append(activeGame.copy() as! PongGame) // Adds the current cup config to turns
        
        updateVisuals()
        /*if activeGame.getCount(array: activeGame.cupConfig) == 0{
            finalScoreLabel.text = "Final Score: \(String(Int(activeGame.score)))"
            Animations.springAnimateIn(viewToAnimate: winnersView, blurView: blurEffectView, view: self.view)
        }*/
    }
    func setTable(tableArrangement: ([[Bool]], Int)){
        /* Takes in a cup configuration and a table type (offset pyramid, grid, or other) and places the cups according to the configuration it is given
        */
        activeGame.cupConfig = tableArrangement.0
        let tableType = tableArrangement.1
        tableView.clearView()
        
        // Dimensions and position variables
        let largestRowCount = activeGame.getLargestRowCount(cupConfig: activeGame.cupConfig)
        var dimension = Double(tableView.bounds.width)/Double(largestRowCount)
        if dimension > 100{ // sets the max size that a cup can be
            dimension = 100
        }
        var isNotGrid = 1.0 // 0: it is a grid config, 1: it is not a grid config
        if tableType == 2 {
            isNotGrid = 0.0
        }
        let rowLength = activeGame.cupConfig[0].count
        let colLength = activeGame.cupConfig.count
        let sidePadding = (Double(tableView.bounds.width) - Double(rowLength) * dimension)/2
        var xPos = 0.0
        var yPos = 0.0
        yPos = (Double(tableView.bounds.height) - ((dimension*Double(colLength - 1) - dimension*Double(colLength - 1)*0.12*isNotGrid) + dimension))/2
        
        for row in 0..<activeGame.cupConfig.count{
            // Sets the starting xPos (stays 0 if the tableType is a grid)
            xPos = sidePadding + (dimension/2 * Double(row)) * isNotGrid
            // Cycles through the cupConfig array and sets the table accordingly
            for col in 0..<activeGame.cupConfig[0].count{
                let newCup = Cup(frame: CGRect(x: xPos, y: yPos, width: dimension, height: dimension))
                if activeGame.cupConfig[row][col]{
                    newCup.location = (row, col)
                    newCup.delegate = self
                    tableView.addSubview(newCup)
                }
                xPos += dimension
            }
            yPos += dimension - (0.12*dimension*isNotGrid)
        }
    }
    func updateVisuals(){
        activeGame.updateScore()
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScoreLabel.text = "WEIGHTED SCORE: \(Int(activeGame.score))"
        //ChartSetup.updateChart(chartView: chartView, noDataLabel: noDataLabel, turnNodes: getTurnNodes())
    }
    
    override func viewDidLoad() {
        // start a new game
        activeGame = PongGame()
        
        // Set up table
        tableView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        self.view.addSubview(tableView)
        tableView.setSize()
        tableView.center.y = currentScoreLabel.center.y + (missedButton.center.y - currentScoreLabel.center.y)/2 - 65
        tableView.backgroundColor = .gray
        setTable(tableArrangement: CupConfigs.pyramid(numBase: 4))
        
        // Set the initial turn
        activeGame.tableView = tableView
        turns.append(activeGame.copy() as! PongGame)
        
        // Custon missed button appearance
        missedButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        missedButton.layer.shadowOpacity = 1
        missedButton.layer.shadowRadius = 0
        missedButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        missedButton.layer.cornerRadius = 15
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func missedButtonTapped(_ sender: Any) {
        takeTurn(turnType: 1, playedCup: false)
    }
}

extension PongGameVC: CupDelegate {
    func didTap(cup: Cup) {
        takeTurn(turnType: 0, playedCup: cup)
    }
    
    func didLongPress(cup: Cup, longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began {
            takeTurn(turnType: 2, playedCup: cup)
        }
    }
}
