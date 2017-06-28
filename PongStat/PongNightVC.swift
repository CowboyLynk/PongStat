//
//  PongNightVC.swift
//  PongStat
//
//  Created by Cowboy Lynk on 6/28/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import UIKit
import Charts

class PongNightVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    var time: String!
    
    // Functions
    func addChart(chart: LineChartView, nodes: [String]){
        ChartSetup.setUpChart(chartView: chart)
        var scores = [ChartDataEntry]()
        var colors = [UIColor]()
        var counter = 1.0
        for node in nodes{
            // gets the time and score
            let index = node.characters.index(of: "%")
            time = node.substring(to: index!)
            let scoreIndex = node.index(index!, offsetBy: 1)
            let score = Int(Double(node.substring(from: scoreIndex))!)
            
            // Sets the graph
            scores.append(ChartDataEntry(x: counter, y: Double(score)))
            counter += 1.0
            colors.append(UIColor.white)
            
            let chartDataSet = LineChartDataSet(values: scores, label: "Efficiency")
            
            // Styling
            chartDataSet.setColors(UIColor.white)
            chartDataSet.circleColors.remove(at: 0)
            chartDataSet.circleColors.append(contentsOf: colors)
            //chartDataSet.fillColor = UIColor(red:0.39, green:0.78, blue:0.56, alpha:1.0)
            chartDataSet.circleRadius = 6
            chartDataSet.circleHoleRadius = 3
            //chartDataSet.circleHoleColor = UIColor(red:0.29, green:0.58, blue:0.41, alpha:1.0)
            chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
            chartDataSet.drawValuesEnabled = true
            chartDataSet.valueTextColor = .white
            chartDataSet.valueFont = UIFont(name: "HelveticaNeue-Bold", size: 14)!
            chartDataSet.lineWidth = 3
            chartDataSet.drawFilledEnabled = false
            chart.leftAxis.axisMinimum = 0
            chart.leftAxis.axisMaximum = 120.0
            chart.xAxis.axisMinimum = 0.8
            chart.xAxis.axisMaximum = (scores.last?.x)! + 0.2
            chart.backgroundColor = UIColor(colorLiteralRed: 0.36, green: 0.64, blue: 0.48, alpha: 1.0)
            
            let chartData = LineChartData(dataSet: chartDataSet)
            chart.data = chartData
        }
    }

    override func viewDidLoad() {
        var yPos = 15
        scrollView.contentSize.height = 0
        
        let nights = (UserDefaults.standard.array(forKey: "PongNight")?.reversed())
        if (nights != nil){
            for night in nights!{
                let view = UIView(frame: CGRect(x: 0, y: yPos, width: Int(self.view.bounds.width*0.95), height: 200))
                let nightChart = LineChartView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 150))
                let chartInfoView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
                let chartInfo = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
                chartInfo.textAlignment = .center
                chartInfo.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
                chartInfo.textColor = UIColor(red:0.56, green:0.59, blue:0.62, alpha:1.0)
                
                chartInfoView.backgroundColor = .white
                chartInfoView.addSubview(chartInfo)
                view.center.x = self.view.center.x
                
                //Makes a new chart
                addChart(chart: nightChart, nodes: night as! [String])
                
                chartInfo.text = "GAME ON: \(time!)"
                yPos += 230
                view.addSubview(nightChart)
                view.addSubview(chartInfoView)
                view.layer.shadowRadius = 7
                view.layer.shadowOpacity = 0.2
                //view.layer.shadowOffset = CGSize(width: 0, height: 5)
                view.layer.cornerRadius = 20
                scrollView.addSubview(view)
                scrollView.contentSize.height += 230
            }
        }
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
