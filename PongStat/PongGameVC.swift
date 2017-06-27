//
//  PongGameVC.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/21/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit
import Charts

class PongGameVC: UIViewController {
    // Variables
    var numBase = 4
    var activeGame: PongGame!
    var tableView: UIView!
    var turns = [PongGame]()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet var reRackView: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // Winner View Outlets
    @IBOutlet var winnerView: UIView!
    @IBOutlet weak var wvFinalScore: UILabel!
    // Winner View Actions
    @IBAction func wvUndoButtonPressed(_ sender: Any) {
        Animations.animateOut(viewToAnimate: winnerView, blurView: blurEffectView)
        undo()
    }
    @IBAction func wvPlayAgainButtonPressed(_ sender: Any) {
        Animations.animateOut(viewToAnimate: winnerView, blurView: blurEffectView)
        reset()
    }
    @IBAction func wvEndNightButtonPressed(_ sender: Any) {
    }

    // Actions
    @IBAction func undoButtonTapped(_ sender: Any) {
        undo()
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        reset()
    }
    @IBAction func reRackButtonTapped(_ sender: Any) {  // The user pushed the button to re-rack the table
        reRackView.clearView()
        Animations.normalAnimateIn(viewToAnimate: reRackView, blurView: blurEffectView, view: self.view)
        reRackView.center = self.view.center
        reRackView.center.y = self.view.bounds.height/2
        
        // Position variables
        var xPos = 25
        var yPos = 64
        var counter = 1
        for reRackOption in activeGame.getPossibleReRacks(){
            reRackView.addSubview(reRackOption)
            reRackOption.addTarget(self, action: #selector(reRackOptionTapped(sender:)), for: .touchUpInside)
            reRackOption.frame.origin = CGPoint(x: xPos, y: yPos)
            xPos += 150
            if counter % 2 == 0{
                xPos = 25
                yPos += 150
            }
            counter += 1
        }
    }
    func reRackOptionTapped(sender: reRackOption){
        if (sender.newTableView != nil){ // runs if the user selects a non-grid-aligned reRack
            activeGame.cupConfig = sender.tableArrangement.0
            
            // Takes all the cups from the new reRack and places them on the tableView
            tableView.swapView(newView: sender.newTableView)
            activeGame.tableView = tableView
            tableView.setSize()
            // Adds the delegate to each of the new cups so that they respond to taps
            for subview in tableView.subviews{
                let cup = subview as! Cup
                cup.delegate = self
            }
        } else {  // runs if the user selects a reRack that can be placed on a grid configuration
            setTable(tableArrangement: sender.tableArrangement)
        }
        Animations.animateOut(viewToAnimate: reRackView, blurView: blurEffectView)
        takeTurn(turnType: 4, playedCup: false)
    }
    @IBAction func closeReRackButtonTapped(_ sender: Any) {
        Animations.animateOut(viewToAnimate: reRackView, blurView: blurEffectView)
    }
    
    
    // Functions
    func takeTurn(turnType: Int, playedCup: Any) { // 0: User made the cup, 1: User missed a cup, 2: partner made a cup, 3: reRack
        activeGame.turnType = turnType
        switch turnType{
        case 1:  // User missed the cup
            activeGame.missedCounter += 1
        case 0, 2:  // A cup was made
            let playedCup = playedCup as! Cup
            playedCup.removeCup()
            activeGame.cupConfig[playedCup.location.0][playedCup.location.1] = false
            if turnType == 0{ // Made by user
                //let multiplier = 1 + 0.1 * Double(6 - activeGame.calcCupsAround(cup: playedCup))
                let multiplier = 1.0
                activeGame.madeCounter += multiplier
            }
            //checkForReReck()
        default: break
        }
        activeGame.updateScore()
        turns.append(activeGame.copy() as! PongGame) // Adds the current cup config to turns
        
        updateVisuals()
        
        if activeGame.getCount(array: activeGame.cupConfig) == 0{
            wvFinalScore.text = "Final Score: \(String(Int(activeGame.score)))"
            Animations.springAnimateIn(viewToAnimate: winnerView, blurView: blurEffectView, view: self.view)
        }
    }
    func setTable(tableArrangement: ([[Bool]], Int, Int)){  // (cupConfig, gridType, rotation angle)
        /* Takes in a cup configuration and a grid type (offset pyramid, grid, or other) and places the cups according to the configuration it is given
        */
        activeGame.cupConfig = tableArrangement.0
        let tableType = tableArrangement.1
        tableView.clearView()
        
        // DIMENSIONS and POSITIONS variables
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
        
        
        // SETTING OF THE TABLE (placing the cups)
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
        
        // ROTATES the table by the correct amount
        tableView.rotate(by: -CGFloat(tableArrangement.2)*CGFloat.pi/2)
        if tableType == 1{
            tableView.transform.tx = self.view.bounds.width * 0.05
        } else{
            tableView.transform.tx = 0
        }
    }
    func updateVisuals(){
        activeGame.updateScore()
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScoreLabel.text = "WEIGHTED SCORE: \(Int(activeGame.score))"
        ChartSetup.updateChart(chartView: chartView, noDataLabel: noDataLabel, turnNodes: getTurnNodes())
    }
    func undo(){
        if turns.count > 1{
            turns.removeLast()
            activeGame = turns.last?.copy() as! PongGame
            
            // Takes all the cups from the new reRack and places them on the tableView
            tableView.swapView(newView: activeGame.tableView)
            activeGame.tableView = tableView // Sets the now updated tableView to be the one that updates in the game
            
            updateVisuals()
            //checkForReReck()
        }
    }
    func reset(){
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            // Resets table
            self.activeGame = PongGame()  // creates a new game
            self.activeGame.tableView = self.tableView
            self.tableView.clearView()
            self.setTable(tableArrangement: ReRacks.pyramid(numBase: self.numBase).tableArrangement)
            self.turns.removeAll()
            self.turns.append(self.activeGame.copy() as! PongGame)
            print(self.activeGame.cupConfig)
            self.updateVisuals()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func getTurnNodes() -> [(Int, PongGame)]{  // Returns only turns that are makes or misses for the graph nodes
        var turnNodes = [(Int, PongGame)]()
        for turn in turns{
            if turn.turnType == 0 || turn.turnType == 1{
                turnNodes.append((turn.turnType, turn))
            }
        }
        return turnNodes
    }
    
    
    override func viewDidLoad() {
        // start a new game
        activeGame = PongGame()
        
        // Set up table
        tableView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        //tableView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.view.addSubview(tableView)
        tableView.setSize()
        tableView.center.y = currentScoreLabel.center.y + (missedButton.center.y - currentScoreLabel.center.y)/2 - 65
        setTable(tableArrangement: ReRacks.pyramid(numBase: numBase).tableArrangement)
        ChartSetup.setUpChart(chartView: chartView)
        
        // Set the initial turn
        activeGame.tableView = tableView
        turns.append(activeGame.copy() as! PongGame)
        
        // Custon missed button appearance
        missedButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        missedButton.layer.shadowOpacity = 1
        missedButton.layer.shadowRadius = 0
        missedButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        missedButton.layer.cornerRadius = 15
        
        // Initializes whole-screen blur view (used in many pop-ups)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        
        // Nav bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
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
