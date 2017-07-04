//
//  PongNightVC.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/28/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit
import Charts

class PongNightsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noGamesLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // Actions
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    
    // Variables
    var nightDate: String!
    var nightChart: LineChartView!
    
    // Functions
    func addChart(chart: LineChartView, nodes: [String]){
        
        // Sets the date of the graph
        let index = nodes.last?.characters.index(of: "%")
        nightDate = nodes.last?.substring(to: index!)
        
        // Adds all the ofhter values
        ChartSetup.setUpChart(chartView: chart)
        var scores = [ChartDataEntry]()
        var colors = [UIColor]()
        var counter = 1.0
        for node in nodes{
            // Gets the TIME and SCORE
            let scoreStartIndex = node.getIndex(of: "%") + 1
            let scoreEndIndex = node.getIndex(of: "*")
            let score = Int(Double(node[scoreStartIndex ..< scoreEndIndex])!)
            let isWin = Bool(node[scoreEndIndex + 1 ..< node.characters.count])
            
            // Adds the nodes the graph
            scores.append(ChartDataEntry(x: counter, y: Double(score)))
            counter += 1.0
            if isWin! {
                colors.append(UIColor.white)
            } else {
                colors.append(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0))
            }
            
            let chartDataSet = LineChartDataSet(values: scores, label: "Efficiency")
            
            // Styling
            chartDataSet.setColors(UIColor.white)
            chartDataSet.circleColors.remove(at: 0)
            chartDataSet.circleColors.append(contentsOf: colors)
            chartDataSet.fillColor = UIColor(red:0.39, green:0.78, blue:0.56, alpha:1.0)
            chartDataSet.circleRadius = 6
            chartDataSet.circleHoleRadius = 3
            chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
            chartDataSet.drawValuesEnabled = true
            chartDataSet.valueTextColor = .white
            chartDataSet.valueFont = UIFont(name: "HelveticaNeue-Bold", size: 14)!
            chartDataSet.lineWidth = 3
            chartDataSet.drawFilledEnabled = true
            chart.leftAxis.axisMinimum = -10
            chart.leftAxis.axisMaximum = 120.0
            chart.xAxis.axisMinimum = 0.8
            chart.xAxis.axisMaximum = (scores.last?.x)! + 0.2
            //chart.backgroundColor = UIColor(colorLiteralRed: 0.36, green: 0.64, blue: 0.48, alpha: 1.0)
            
            let chartData = LineChartData(dataSet: chartDataSet)
            chart.data = chartData
        }
    }
    func clearNights(){
        let alert = UIAlertController(title: "Reset all night graphs?", message: "Are you sure that you want to erase all night scores?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            UserDefaults.standard.set(nil, forKey: "PongNight")
            self.viewDidLoad()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        // Clears the view
        scrollView.clearView()
        
        //Adds bar button item
        let restartButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Restart"), style: .plain, target: self, action: #selector(clearNights))
        tabBarController?.navigationItem.setRightBarButtonItems([restartButton], animated: true)
        
        var yPos = 15
        scrollView.contentSize.height = 0
        
        let nights = (UserDefaults.standard.array(forKey: "PongNight")?.reversed())
        if (nights != nil){
            noGamesLabel.isHidden = true
            for night in nights!{
                // Creates the views that display the night's information
                let view = UIView(frame: CGRect(x: 0, y: yPos, width: Int(self.view.bounds.width*0.95), height: 200))
                nightChart = LineChartView(frame: CGRect(x: 0, y: 60, width: view.bounds.width, height: 150))
                let chartInfoView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 75))
                let chartInfo = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
                let background = UIView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 100))
                
                // Adds all the scores to the chart
                addChart(chart: nightChart, nodes: night as! [String])
                
                // Styles the night charts' views
                nightChart.animate(yAxisDuration: 1)
                chartInfo.textAlignment = .center
                chartInfo.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
                chartInfo.textColor = UIColor(red:0.56, green:0.59, blue:0.62, alpha:1.0)
                chartInfo.text = "NIGHT OF: \(nightDate!)"
                chartInfoView.backgroundColor = .white
                chartInfoView.layer.cornerRadius = 5
                view.center.x = self.view.center.x
                view.layer.shadowRadius = 7
                view.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.layer.shadowOpacity = 0.2
                view.layer.cornerRadius = 5
                view.backgroundColor = UIColor(colorLiteralRed: 0.36, green: 0.64, blue: 0.48, alpha: 1.0)
                background.backgroundColor = UIColor(colorLiteralRed: 0.36, green: 0.64, blue: 0.48, alpha: 1.0)
                
                // Adds all the subviews
                chartInfoView.addSubview(chartInfo)
                view.addSubview(chartInfoView)
                view.addSubview(background)
                view.addSubview(nightChart)
                scrollView.addSubview(view)
                
                // Increments certain variables
                scrollView.contentSize.height += 230
                yPos += 230
                
            }
        } else {
            noGamesLabel.isHidden = false
        }
    
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
