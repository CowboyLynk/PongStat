//
//  Charts.swift
//  PongStatUpdate
//
//  Created by Cowboy Lynk on 6/15/17.
//  Copyright © 2017 Cowboy Lynk. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartSetup{
    static func setUpChart(chartView: LineChartView){
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
    static func updateChart(chartView: LineChartView, noDataLabel: UILabel, turnNodes: [(Int, PongGame)]){
        var scores = [ChartDataEntry]()
        var colors = [UIColor]()
        if turnNodes.count > 0{
            noDataLabel.isHidden = true
            scores.append(ChartDataEntry(x: -1, y: turnNodes[0].1.score))
            colors.append(UIColor.white)
            for i in 0..<turnNodes.count{
                scores.append(ChartDataEntry(x: Double(i), y: turnNodes[i].1.score))
                if turnNodes[i].0 == 0 {
                    colors.append(UIColor.white)
                } else {
                    colors.append(UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0))
                }
            }
        } else {
            noDataLabel.isHidden = false
        }
        let chartDataSet = LineChartDataSet(values: scores, label: "Efficiency")
        
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
}
