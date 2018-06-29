//
//  ChartData.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

enum MagicLineStyle {
    case line
    case curve
}

enum MagicChartAxisRangeType {
    case auto
    case zero
    case manual
}

enum MagicChartPointShape {
    case circle
    case square
    case triangle
}

class LineChartDataSource {
    var label = [String]()
    var sets = [LineChartDataSet]()
}

class LineChartDataSet {
    var value = [String: Double]()
    
    var lineWidth: CGFloat = 1
    var lineColor: UIColor?
    var lineDashPattern: [[Double]] = []
    var lineStyle: MagicLineStyle = .line
    
    var pointShape: MagicChartPointShape? = nil
    var pointRadius: CGFloat = 4
}
