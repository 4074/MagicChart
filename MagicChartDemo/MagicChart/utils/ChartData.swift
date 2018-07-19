//
//  ChartData.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public enum MagicLineStyle {
    case line
    case curve
}

public enum MagicChartAxisRangeType {
    case auto
    case zero
    case manual
}

public enum MagicChartPointShape {
    case circle
    case square
    case triangle
}

public enum AxisChartAxisPosition {
    case top
    case left
    case right
    case bottom
}

public class LineChartDataSource {
    var label = [String]()
    var sets = [LineChartDataSet]()
}

public class LineChartDataSet {
    var value = [String: Double]()
    
    var lineWidth: CGFloat = 1
    var lineColor: UIColor?
    var lineDashPattern: [[Double]] = []
    var lineStyle: MagicLineStyle = .line
    var xAxisPosition: AxisChartAxisPosition = .bottom
    var yAxisPosition: AxisChartAxisPosition = .left
    
    var pointConfig: LineChartPointConfig? = nil
}


