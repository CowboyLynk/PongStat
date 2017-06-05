//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/29/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit
import Charts

class PongGameVC: UIViewController {
    // Variables
    var numCups = 10
    var activeGame: PongGame!
    var cup: Cup!
    var reRackPlaceholder: reRackSwitch!
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noDataLabel: UILabel!
    // Winner view outlets
    @IBOutlet var winnerView: UIView!
    @IBOutlet weak var finalScore: UILabel!
    // ReRack view outlets
    @IBOutlet var reRackView: UIView!
    
    // Actions
    @IBAction func undoButtonTapped(_ sender: Any) {
        undo()
    }
    @IBAction func reRackButtonTapped(_ sender: Any) {
        setReRackView()
        springAnimateIn(viewToAnimate: reRackView)
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            // Resets table
            self.clearTable()
            self.setTable()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    // Winner view actions
    @IBAction func undoGameOver(_ sender: Any) {
        undo()
        animateOut(viewToAnimate: self.winnerView)
    }
    @IBAction func playAgain(_ sender: Any) {
        clearTable()
        setTable()
        animateOut(viewToAnimate: self.winnerView)
    }
    // Rerack view actions
    @IBAction func setRack(_ sender: Any) {
        for view in table.subviews{
            view.removeFromSuperview()
        }
        animateOut(viewToAnimate: self.reRackView)
        
        // Set table
        let numBase = activeGame.numBase
        let screenSize: CGRect = self.table.bounds
        var xValue = 0
        var yValue = 0
        let dimension = Int(Int(screenSize.width)/numBase)
        for i in 0..<numBase {
            xValue = dimension*i/2
            for j in 0..<numBase-i {
                if activeGame.reRackConfig[i][j] {
                    // Make cup
                    cup = Cup(frame: CGRect(x: xValue, y: yValue, width: dimension, height: dimension))
                    cup.location = (i, j)
                    cup.delegate = self
                    // Add cup
                    self.table.addSubview(cup)
                    activeGame.cupConfig[i][j] = true
                }
                xValue += dimension
            }
            yValue += Int(Double(dimension)*0.85)
        }
    }
    
    
    // Cup interactions
    @IBAction func missed(_ sender: Any) {  // User missed the cup
        activeGame.missedCounter += 1
        activeGame.turns.append(("miss", false as AnyObject, 1.0, activeGame.getScore()))
        updateVisuals()
    }

    // Functions
    func updateVisuals() {
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScore.text = "WEIGHTED SCORE: \(activeGame.getScore())"
        updateChart()
    }
    func removeCup(cup: Cup) {
        let location = cup.location
        activeGame.cupConfig[(location.0)][(location.1)] = false
        cup.isUserInteractionEnabled = false
        cup.clear()
        if activeGame.getCupCount() == 0{
            springAnimateIn(viewToAnimate: self.winnerView)
        }
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
        for i in 0..<numBase {
            xValue = dimension*i/2
            for j in 0..<numBase-i {
                // Make cup
                cup = Cup(frame: CGRect(x: xValue, y: yValue, width: dimension, height: dimension))
                cup.location = (i, j)
                cup.delegate = self
                // Add cup
                self.table.addSubview(cup)
                activeGame.cupConfig[i][j] = true
                xValue += dimension
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
        animateOut(viewToAnimate: self.winnerView)
        animateOut(viewToAnimate: self.reRackView)
    }
    func setReRackView(){
        let numBase = activeGame.numBase
        activeGame.reRackConfig = Array(repeating: Array(repeating: false, count: numBase), count: numBase)
        let screenSize: CGRect = self.reRackView.bounds
        var xValue = 0
        var yValue = 60
        let dimension = Int(Int(screenSize.width)/numBase)
        for i in 0..<numBase {
            xValue = dimension*i/2
            for j in 0..<numBase-i {
                // Make cup
                reRackPlaceholder = reRackSwitch(frame: CGRect(x: xValue, y: yValue, width: dimension, height: dimension))
                reRackPlaceholder.location = (i, j)
                reRackPlaceholder.layer.cornerRadius = CGFloat(dimension/2)
                reRackPlaceholder.addTarget(self, action: #selector(reRackPlaceholderTapped(sender:)), for: .touchUpInside)
                // Add cup
                self.reRackView.addSubview(reRackPlaceholder)
                xValue += dimension
            }
            yValue += Int(Double(dimension)*0.85)
        }
        activeGame.cupConfig = activeGame.reRackConfig
    }
    func reRackPlaceholderTapped(sender:reRackSwitch!){
        sender.isPressed()
        let location = sender.location
        activeGame.reRackConfig[location.0][location.1] = sender.switchState
    }
    func undo(){
        // this is messy, don't force unwrap the optionals
        if activeGame.turns.count > 0 {
            let lastTurn = activeGame.turns.last
            let turnType = lastTurn?.0
            if turnType != "miss"{
                let cup = lastTurn?.1 as! Cup
                replaceCup(cup: cup)
                if turnType == "make"{
                    activeGame.madeCounter -= (lastTurn?.2)!
                }
            } else { // if its a miss
                activeGame.missedCounter -= 1
            }
            activeGame.turns.removeLast()
            updateVisuals()
        }
    }
    func setUpChart(){
        chartView.noDataText = ""
        chartView.leftAxis.axisMinimum = -10
        chartView.leftAxis.axisMaximum = 110.0
        chartView.leftAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.noDataTextColor = UIColor.white
        chartView.gridBackgroundColor = UIColor.white
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.chartDescription?.text = ""
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
    }
    func updateChart(){
        var scores = [ChartDataEntry]()
        var colors = [UIColor]()
        let count = activeGame.getNumNodes()
        if count > 0{
            let turns = activeGame.turns
            noDataLabel.isHidden = true
            scores.append(ChartDataEntry(x: 0, y: Double(turns[0].3)))
            colors.append(UIColor.white)
            for i in 0..<activeGame.turns.count {
                let shot = turns[i].0
                if shot == "make" {
                    colors.append(UIColor.white)
                }
                else if shot == "miss" {
                    colors.append(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0))
                }
                let entry = ChartDataEntry(x: Double(i+1), y: Double(turns[i].3))
                scores.append(entry)
            }
        } else {
            noDataLabel.isHidden = false
        }
        let chartDataSet = LineChartDataSet(values: scores, label: "Efficiency")
        
        //chartView.xAxis.axisMaximum = Double(chartCounter + 1)
        //chartView.setVisibleXRangeMaximum(5)
        //chartView.xAxis.xOffset = 5
        //chartView.moveViewToX(Double(chartCounter))
        
        // Styling
        chartDataSet.setColors(UIColor.white)
        chartDataSet.circleColors.remove(at: 0)
        chartDataSet.circleColors.append(contentsOf: colors)
        chartDataSet.fillColor = UIColor(red:0.39, green:0.78, blue:0.56, alpha:1.0)
        chartDataSet.circleRadius = 6
        chartDataSet.circleHoleRadius = 3
        chartDataSet.circleHoleColor = UIColor(red:0.29, green:0.58, blue:0.41, alpha:1.0)
        chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
        chartDataSet.drawValuesEnabled = false
        chartDataSet.lineWidth = 3
        chartDataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: chartDataSet)  // Error occurs here
        chartView.data = chartData
    }
    
    // Animations
    func springAnimateIn(viewToAnimate: UIView){
        // gets final score
        finalScore.text = "Final Score: \(activeGame.getScore())"
        
        // Adds BG blur
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        
        // Adds view to main screen
        self.view.addSubview(viewToAnimate)
        viewToAnimate.alpha = 0
        viewToAnimate.center = CGPoint.init(x: self.view.center.x, y: self.view.bounds.height)
        viewToAnimate.layer.shadowColor = UIColor.black.cgColor
        viewToAnimate.layer.shadowOpacity = 0.3
        viewToAnimate.layer.shadowOffset = CGSize.zero
        viewToAnimate.layer.shadowRadius = 20
        
        UIView.animate(withDuration: 0.4){
            viewToAnimate.alpha = 1
            self.blurEffectView.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [] , animations: {
            viewToAnimate.center = CGPoint.init(x: self.view.center.x, y: self.view.bounds.height/2)
        }, completion: nil)
    }
    func animateOut(viewToAnimate: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 0
            viewToAnimate.alpha = 0
            viewToAnimate.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            
        }) { (sucsess:Bool) in
            viewToAnimate.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nav bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Chart
        setUpChart()
        
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

}

extension PongGameVC: CupDelegate {
    func didTap(cup: Cup) {
        let multiplier = 1 + 0.1 * Double(5 - activeGame.calcCupsAround(cup: cup))
        activeGame.madeCounter += multiplier
        activeGame.turns.append(("make", cup, multiplier, activeGame.getScore()))
        removeCup(cup: cup)
        updateVisuals()
    }

    func didLongPress(cup: Cup, longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == .began {
            activeGame.turns.append(("remove", cup, 0.0, activeGame.getScore()))
            removeCup(cup: cup)
        }
    }
}


