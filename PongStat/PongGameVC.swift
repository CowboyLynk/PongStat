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
    var startGameTime: Date!
    var numInitialCups = 10
    var numBase = 4
    var activeGame: PongGame!
    var activeNight: PongNight!
    var gameNumber = 1.0
    var tableView: UIView!
    var turns = [PongGame]()
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    var menuBlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    var menuGestureRecognizer = UITapGestureRecognizer()
    var menuActivated = false
    var isWin = true
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet var reRackView: UIView!
    @IBOutlet weak var reRackScrollView: UIScrollView!
    @IBOutlet weak var setRackButton: UIButton!
    @IBOutlet weak var reRackTableView: UIView!
    @IBOutlet weak var reRackTitleLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Cup Prompt Outlets
    @IBOutlet var cupPromptView: UIView!
    @IBOutlet weak var cupPromptTextField: UITextField!
    // Cup Prompt Actions
    @IBAction func cupPromptPlayButtonPressed(_ sender: Any) {
        let enteredField = cupPromptTextField.text
        if enteredField != ""{
            let numCups = Int(enteredField!)!
            if numCups > 0 && numCups < 40{
                cupPromptTextField.resignFirstResponder()
                Animations.animateOut(viewToAnimate: cupPromptView, blurView: blurEffectView)
                numInitialCups = numCups
                reset()
            } else{
            }
        }
        cupPromptTextField.text = ""
    }
    
    // Winner View Outlets
    @IBOutlet var winnerView: UIView!
    @IBOutlet weak var wvFinalScore: UILabel!
    @IBOutlet weak var wvImage: UIImageView!
    // Winner View Actions
    @IBAction func wvUndoButtonPressed(_ sender: Any) {
        Animations.animateOut(viewToAnimate: winnerView, blurView: blurEffectView)
        undo()
    }
    @IBAction func wvPlayAgainButtonPressed(_ sender: Any) {
        // Adds the game to the night graph
        activeNight.addGame(time: startGameTime, score: activeGame.score, isWin: isWin)
        gameNumber += 1.0
        presetNumCupsPrompt()
        navigationItem.title = "Game \(Int(gameNumber))"
        
    }
    @IBAction func wvEndNightButtonPressed(_ sender: Any) {
        activeNight.addGame(time: startGameTime, score: activeGame.score, isWin: isWin)
        activeNight.removeLastNight()
        self.performSegue(withIdentifier: "returnToHome", sender: StartViewController())
    }

    // ACTIONS
    @IBAction func menuButtonTapped(_ sender: Any) {
        toggleMenu()
    }
    @IBAction func undoButtonTapped(_ sender: Any) {
        undo()
    }
    // Re Rack Actions
    @IBAction func reRackButtonTapped(_ sender: Any) {  // The user pushed the button to re-rack the table
        reRackScrollView.clearView()
        setRackButton.alpha = 0
        reRackTableView.alpha = 0
        reRackTableView.clearView()
        activeGame.reRackConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        reRackTitleLabel.text = "SELECT A RERACK"
        
        // Position variables
        var xPos = 25
        var yPos = 89
        var counter = 1
        var rowCounter = 0
        // Adds all the buttons for remaining-cup-dependant reracks
        for reRackOption in activeGame.getPossibleReRacks(){
            //Adds the button
            let reRack = reRackOption as! reRackOption
            reRackScrollView.addSubview(reRack)
            reRack.addTarget(self, action: #selector(reRackOptionTapped(sender:)), for: .touchUpInside)
            reRack.frame.origin = CGPoint(x: xPos, y: yPos)
            
            // Increments certain variables
            xPos += 150
            if counter % 2 == 0{
                xPos = 25
                yPos += 150
            }
            if (counter - 1) % 2 == 0{
                rowCounter += 1
            }
            counter += 1
        }
        
        
        reRackView.frame.size = CGSize(width: reRackView.frame.width, height: CGFloat(89 + 150*rowCounter))
        reRackView.center = self.view.center
        reRackView.center.y = self.view.bounds.height/2
        Animations.normalAnimateIn(viewToAnimate: reRackView, blurView: blurEffectView, view: self.view)
    }
    @IBAction func setRackButtonPressed(_ sender: Any) {
        if activeGame.getCount(array: activeGame.reRackConfig) == activeGame.getCount(array: activeGame.cupConfig){
            activeGame.cupConfig = activeGame.reRackConfig
            activeGame.removeEmptyEdges()
            setTable(tableArrangement: (activeGame.cupConfig, activeGame.reRackGridType, 0))
            Animations.animateOut(viewToAnimate: reRackView, blurView: blurEffectView)
            takeTurn(turnType: 4, playedCup: false)
        }
    }
    @IBAction func closeReRackButtonTapped(_ sender: Any) {
        Animations.animateOut(viewToAnimate: reRackView, blurView: blurEffectView)
    }
    
    // Menu View Actions
    @IBAction func homeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Exit to Main Menu?", message: "Are you sure that you want to exit to the main menu? Your score for this game (not the whole night) will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.performSegue(withIdentifier: "returnToHome", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func statsButtonPressed(_ sender: Any) {
        // I don't want to remove this because then Xcode will make me place the button again and I'm lazy
    }
    @IBAction func forfeitButtonPressed(_ sender: Any) {
        isWin = false
        toggleMenu()
        cupPromptTextField.resignFirstResponder()
        wvImage.image = #imageLiteral(resourceName: "SadBeer")
        wvFinalScore.text = "Final Score: \(String(Int(activeGame.score)))"
        Animations.springAnimateIn(viewToAnimate: winnerView, blurView: blurEffectView, view: self.view)
    }
    
    
    // Game-play Functions
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
                let cupsAround = activeGame.getCupsAround(forCup: playedCup)
                let multiplier = 1 + 0.1 * Double(6 - cupsAround)
                activeGame.madeCounter += multiplier
            }
            //checkForReReck()
        default: break
        }
        activeGame.updateScore()
        turns.append(activeGame.copy() as! PongGame) // Adds the current cup config to turns
        
        updateVisuals()
        
        if activeGame.getCount(array: activeGame.cupConfig) == 0{
            isWin = true
            wvFinalScore.text = "Final Score: \(String(Int(activeGame.score)))"
            wvImage.image = #imageLiteral(resourceName: "HappyBeer")
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
        var isNotGrid = 1.0 // 0: it is a square grid config, 1: it is not a square grid config
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
            xPos = sidePadding + (dimension/2 * Double(row)) * isNotGrid // Sets the STARTING XPOS (stays 0 if the tableType is a grid)
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
        self.numBase = Int(-1/2*(1 - (8.0*Double(numInitialCups) + 1.0).squareRoot()))
        self.activeGame = PongGame()  // creates a new game
        self.activeGame.tableView = self.tableView
        self.tableView.clearView()
        self.setTable(tableArrangement: ReRacks.pyramid(numBase: self.numBase).tableArrangement)
        self.turns.removeAll()
        self.turns.append(self.activeGame.copy() as! PongGame)
        self.updateVisuals()
    }
    
    // Re Rack Functions
    func reRackOptionTapped(sender: reRackOption){ // e.g. pyramid, custom pyramid, custom grid, etc...
        if sender.name == "Custom"{  // Runs if the user selects a custom reRack
            // Adds the switches to the table
            activeGame.reRackGridType = sender.tableArrangement.1
            var reRackConfiguration: [[Bool]]
            var newHeight: Int
            if activeGame.reRackGridType == 0{
                reRackConfiguration = ReRacks.pyramid(numBase: numBase).tableArrangement.0
                newHeight = 450
            } else {
                reRackConfiguration = Array(repeating: Array(repeating: true, count: numBase), count: numBase)
                newHeight = 475
            }
            setReRackTable(cupConfig: reRackConfiguration, gridType: sender.tableArrangement.1)
            
            // Animates the changing view
            UIView.animate(withDuration: 1, animations: {
                //Fades in the reRack table view
                self.reRackTableView.alpha = 1
                self.setRackButton.alpha = 1
                
                let reRackView = self.reRackView!
                for subview in self.reRackScrollView.subviews{
                    subview.alpha = 0
                }
                
                // Re-centers and re-sizes the view
                reRackView.frame = CGRect(origin: reRackView.frame.origin, size: CGSize(width: reRackView.frame.width, height: CGFloat(newHeight)))
                self.reRackView.center = self.view.center
                self.reRackView.center.y = self.view.bounds.height/2
            })
            //changes the title of the reRack View to show how many cups are left to be placed
            let cupsLeftToPlace = activeGame.getCount(array: activeGame.cupConfig) - activeGame.getCount(array: activeGame.reRackConfig)
            reRackTitleLabel.text = "LEFT TO PLACE: \(cupsLeftToPlace)"
        } else {
            if (sender.newTableView != nil) { // runs if the user selects a non-grid-aligned reRack
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
    }
    func reRackSwitchTapped(sender: reRackSwitch){
        sender.isPressed()
        activeGame.reRackConfig[sender.location.0][sender.location.1] = sender.switchState
        
        // updates the title of the reRack View to show how many cups are left to be placed
        let cupsLeftToPlace = activeGame.getCount(array: activeGame.cupConfig) - activeGame.getCount(array: activeGame.reRackConfig)
        reRackTitleLabel.text = "LEFT TO PLACE: \(cupsLeftToPlace)"
        
        // disables touch if the user has placed the right amount of cups
        if cupsLeftToPlace == 0{
            makeReRackSwitchTouchDisabled()
        } else if cupsLeftToPlace > 0{
            for subview in reRackTableView.subviews{
                subview.isUserInteractionEnabled = true
            }
        }
    }
    func setReRackTable(cupConfig: [[Bool]], gridType: Int){
        
        // DIMENSIONS and POSITIONS variables
        var dimension = Double(reRackTableView.bounds.width)/Double(numBase)
        if dimension > 100{ // sets the max size that a cup can be
            dimension = 100
        }
        var isNotGrid = 1.0 // 0: it is a square grid config, 1: it is not a square grid config
        if gridType == 2 {
            isNotGrid = 0.0
        }
        let rowLength = cupConfig[0].count
        let sidePadding = (Double(reRackTableView.bounds.width) - Double(rowLength) * dimension)/2
        var xPos = 0.0
        var yPos = 0.0
        //yPos = (Double(reRackTableView.bounds.height) - ((dimension*Double(colLength - 1) - dimension*Double(colLength - 1)*0.12*isNotGrid) + dimension))/2
        
        // SETTING OF THE TABLE (placing the cups)
        for row in 0..<cupConfig.count{
            xPos = sidePadding + (dimension/2 * Double(row)) * isNotGrid // Sets the STARTING XPOS (stays 0 if the tableType is a grid)
            // Cycles through the cupConfig array and sets the table accordingly
            for col in 0..<cupConfig[0].count{
                let newReRackSwitch = reRackSwitch(frame: CGRect(x: xPos, y: yPos, width: dimension*0.8, height: dimension*0.8))
                if cupConfig[row][col]{
                    newReRackSwitch.location = (row, col)
                    newReRackSwitch.addTarget(self, action: #selector(reRackSwitchTapped(sender:)), for: .touchUpInside)
                    reRackTableView.addSubview(newReRackSwitch)
                }
                xPos += dimension + dimension*0.2/Double(numBase)
            }
            yPos += dimension - (0.12*dimension*isNotGrid)
        }
    }
    func makeReRackSwitchTouchDisabled(){
        for subview in reRackTableView.subviews{
            let reRackSwitch = subview as! reRackSwitch
            if reRackSwitch.switchState != true{
                reRackSwitch.isUserInteractionEnabled = false
            }
        }
    }
    
    // Miscellaneous Functions
    func toggleMenu(){
        menuView.frame = CGRect(x: 0, y: 0, width: 175, height: self.view.bounds.height)
        if !menuActivated{
            Animations.slideAnimateIn(viewToAnimate: menuView, blurView: menuBlurEffectView, view: self.view)
            cupPromptTextField.resignFirstResponder()
            menuButton.image = #imageLiteral(resourceName: "Close-white")
        } else {
            Animations.slideAnimateOut(viewToAnimate: menuView, blurView: menuBlurEffectView)
            cupPromptTextField.becomeFirstResponder()
            menuButton.image = #imageLiteral(resourceName: "Menu")
        }
        menuActivated = !menuActivated
    }
    func presetNumCupsPrompt(){
        cupPromptTextField.becomeFirstResponder()
        Animations.normalAnimateIn(viewToAnimate: cupPromptView, blurView: blurEffectView, view: self.view)
        Animations.animateOut(viewToAnimate: winnerView, blurView: UIVisualEffectView())
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
        
        // Sets the title
        navigationItem.title = "Game 1"
        
        // Initializes whole-screen blur view (used in pop-ups) and the menu gesture recognizer
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuBlurEffectView.frame = view.bounds
        menuBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        menuBlurEffectView.addGestureRecognizer(menuGestureRecognizer)
        
        // Gets the number of cups through a custom notification
        cupPromptView.center = self.view.center
        cupPromptView.center.y = (self.view.bounds.height - 170 - 35)/2
        cupPromptTextField.becomeFirstResponder()
        self.view.addSubview(blurEffectView)
        self.view.addSubview(cupPromptView)
        
        // Starts a new night
        activeNight = PongNight()
        
        // start a new game
        activeGame = PongGame()
        
        // Sets up table
        tableView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width))
        self.view.addSubview(tableView)
        view.sendSubview(toBack: tableView)
        tableView.setSize()
        tableView.center.y = currentScoreLabel.center.y + (missedButton.center.y - currentScoreLabel.center.y)/2 - 65
        ChartSetup.setUpChart(chartView: chartView)
        
        // Set the initial turn so that the user can undo all the way to the begining
        activeGame.tableView = tableView
        turns.append(activeGame.copy() as! PongGame)
        
        // Custon missed button appearance
        missedButton.layer.shadowColor = UIColor(red:0.80, green:0.20, blue:0.10, alpha:1.0).cgColor
        missedButton.layer.shadowOpacity = 1
        missedButton.layer.shadowRadius = 0
        missedButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        missedButton.layer.cornerRadius = 15
        
        // Nav bar
        /*
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        */
        
        // Sets the start time of the game (used to determind the date for the graphs)
        let date = Date()
        startGameTime = date
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func missedButtonTapped(_ sender: Any) {
        takeTurn(turnType: 1, playedCup: false)
    }
    
    /*
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }*/
    
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
