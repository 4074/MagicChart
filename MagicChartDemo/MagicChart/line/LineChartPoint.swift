//
//  LineChartPoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/19.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

open class LineChartPoint: CAShapeLayer {
    var config: LineChartPointConfig!
    var configForState: LineChartPointConfigItem!
    var active: Bool = false {
        didSet {
            if oldValue != active {
                toggleActive()
            }
        }
    }
    
    open func toggleActive() {}
}

public struct LineChartPointConfig {
    let normal: LineChartPointConfigItem
    let active: LineChartPointConfigItem
}

public struct LineChartPointConfigItem {
    let shape: MagicChartPointShape
    let radius: CGFloat
    let hole: CGFloat
    let shadow: CGFloat
    let colors: (point: UIColor, hole: UIColor, shadow: UIColor)
}
