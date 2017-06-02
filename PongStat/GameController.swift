//
//  ViewController.swift
//  PongStat
//
//  Created by Cowboy Lynk on 5/29/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit
import Charts

class GameController: UIViewController {
    // Variables
    var numCups = 10.0
    var cup: Cup!
    var currentCup: Cup!
    var activeGame: PongGame!
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    
    // Outlets
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var table: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet var winnerView: UIView!
    @IBOutlet weak var finalScore: UILabel!
    
    // Actions
    @IBAction func undo(_ sender: Any) {
        if activeGame.turns.count > 0{
            let lastTurn = activeGame.turns.last
            let turnType = lastTurn?.0
            if turnType != "miss"{  // if its a make or a remove
                let cup = lastTurn?.1 as! Cup
                replaceCup(cup: cup)
                if turnType == "make"{  // if its a make
                    activeGame.madeCounter -= lastTurn?.2 as! Double
                    activeGame.nodes.removeLast()
                }
            } else { // if its a miss
                activeGame.missedCounter -= 1
                activeGame.nodes.removeLast()
            }
            activeGame.turns.removeLast()
            updateVisuals()
        }
    }
    @IBAction func reset(_ sender: Any) {
        // Are you SUUUURE you want to reset
        let alert = UIAlertController(title: "Reset table?", message: "Are you sure that you want to reset the table? Your scores will be deleted.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            // Resets table
            self.clearTable()
            self.setTable()
            self.winnerAnimateOut()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func playAgain(_ sender: Any) {
        clearTable()
        setTable()
        winnerAnimateOut()
    }
    
    // Cup interactions
    @IBAction func missed(_ sender: Any) {  // User missed the cup
        activeGame.missedCounter += 1
        activeGame.nodes.append((false, activeGame.getScore()))
        activeGame.turns.append(("miss", false as AnyObject, 1 as AnyObject))
        updateVisuals()
    }
    func normalTap(_ sender: UIGestureRecognizer){  // User made the cup
        setCurrentCup(sender: sender)
        let multiplier = 1 + 0.1 * Double(5 - activeGame.calcCupsAround(cup: currentCup))
        activeGame.madeCounter += multiplier
        activeGame.nodes.append((true, activeGame.getScore()))
        activeGame.turns.append(("make", currentCup, multiplier as AnyObject))
        removeCup(sender: sender)
        updateVisuals()
    }
    func longTap(_ sender: UIGestureRecognizer){  // Someone else made the cup
        if sender.state == .began {
            setCurrentCup(sender: sender)
            activeGame.turns.append(("remove", currentCup, false as AnyObject))
            removeCup(sender: sender)
        }
    }
    
    // Functions
    func updateVisuals() {
        missedButton.setTitle("MISSED: \(activeGame.missedCounter)", for: .normal)
        currentScore.text = "WEIGHTED SCORE: \(activeGame.getScore())"
        updateChart()
    }
    func setCurrentCup(sender: UIGestureRecognizer){
        currentCup = activeGame.cupTags[(sender.view?.tag)!]
    }
    func removeCup(sender: UIGestureRecognizer){
        let location = currentCup.location
        activeGame.cupConfig[(location?.0)!][(location?.1)!] = false
        currentCup.view.isUserInteractionEnabled = false
        currentCup.clear()
        if activeGame.getCupCount() == 0{
            winnerAnimateIn()
        }
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
    func setUpChart(){
        chartView.noDataText = ""
        chartView.leftAxis.axisMinimum = -10
        chartView.leftAxis.axisMaximum = 110.0
        chartView.leftAxis.enabled = false
        chartView.leftAxis.labelTextColor = UIColor.white
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
        if activeGame.nodes.count > 0{
            noDataLabel.isHidden = true
            scores.append(ChartDataEntry(x: 0, y: Double(activeGame.nodes[0].1)))
            colors.append(UIColor.white)
            for i in 0..<activeGame.nodes.count {
                let shot = activeGame.nodes[i].0
                if shot {
                    colors.append(UIColor.white)
                }
                else {
                    colors.append(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0))
                }
                let entry = ChartDataEntry(x: Double(i+1), y: Double(activeGame.nodes[i].1))
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
    func winnerAnimateIn(){
        // gets final score
        finalScore.text = "Final Score: \(activeGame.getScore())"
        
        // Adds BG blur
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        
        // Adds winner screen
        self.view.addSubview(winnerView)
        winnerView.alpha = 0
        winnerView.center = CGPoint.init(x: self.view.center.x, y: self.view.bounds.height)
        winnerView.layer.shadowColor = UIColor.black.cgColor
        winnerView.layer.shadowOpacity = 0.3
        winnerView.layer.shadowOffset = CGSize.zero
        winnerView.layer.shadowRadius = 20
        
        UIView.animate(withDuration: 0.4){
            self.winnerView.alpha = 1
            self.blurEffectView.alpha = 1
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [] , animations: {
            self.winnerView.center = CGPoint.init(x: self.view.center.x, y: self.view.bounds.height/2)
        }, completion: nil)
    }
    func winnerAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 0
            self.winnerView.alpha = 0
            self.winnerView.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            
        }) { (sucsess:Bool) in
            self.winnerView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nav Bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 20))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "Title")
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Set table
        activeGame = PongGame(cups: numCups)
        setTable()
        
        // Set chart
        setUpChart()
        
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

