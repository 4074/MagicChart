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
    public init() {}
    public var label = [String]()
    public var sets = [LineChartDataSet]()
}

public class LineChartDataSet {
    public init() {}
    
    public var value = [String: Double]()
    public var lineWidth: CGFloat = 1
    public var lineColor: UIColor?
    public var lineDashPattern: [[Double]] = []
    public var lineStyle: MagicLineStyle = .line
    public var continuous: Bool = true
    public var xAxisPosition: AxisChartAxisPosition = .bottom
    public var yAxisPosition: AxisChartAxisPosition = .left
    
    public var pointConfig: LineChartPointConfig? = nil
}


