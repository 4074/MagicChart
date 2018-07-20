//
//  LineChartPoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/19.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

open class LineChartPoint: CAShapeLayer {
    open var config: LineChartPointConfig!
    open var configForState: LineChartPointConfigItem!
    open var active: Bool = false {
        didSet {
            if oldValue != active {
                toggleActive()
            }
        }
    }
    
    open func toggleActive() {}
}

public struct LineChartPointConfig {
    public let normal: LineChartPointConfigItem
    public let active: LineChartPointConfigItem
    
    public init(
        normal: LineChartPointConfigItem,
        active: LineChartPointConfigItem
    ) {
        self.normal = normal
        self.active = active
    }
}

public struct LineChartPointConfigItem {
    public let shape: MagicChartPointShape
    public let radius: CGFloat
    public let hole: CGFloat
    public let shadow: CGFloat
    public let colors: (point: UIColor, hole: UIColor, shadow: UIColor)
    
    public init(
        shape: MagicChartPointShape,
        radius: CGFloat,
        hole: CGFloat,
        shadow: CGFloat,
        colors: (point: UIColor, hole: UIColor, shadow: UIColor)
    ) {
        self.shape = shape
        self.radius = radius
        self.hole = hole
        self.shadow = shadow
        self.colors = colors
    }
}




