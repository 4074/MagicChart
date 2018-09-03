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
    public let shape: MagicChartPointShape
    public let normal: (radius: LineChartPointRadius, colors: LineChartPointColor)
    public let active: (radius: LineChartPointRadius, colors: LineChartPointColor)
    
    public init(
        shape: MagicChartPointShape,
        normal: (radius: LineChartPointRadius, colors: LineChartPointColor),
        active: (radius: LineChartPointRadius, colors: LineChartPointColor)
        ) {
        self.shape = shape
        self.normal = normal
        self.active = active
    }
}

public struct LineChartPointColor {
    public let point: UIColor
    public let hole: UIColor
    public let shadow: UIColor
    
    public init(point: UIColor, hole: UIColor, shadow: UIColor) {
        self.point = point
        self.hole = hole
        self.shadow = shadow
    }
}

public struct LineChartPointRadius {
    public let point: CGFloat
    public let hole: CGFloat
    public let shadow: CGFloat
    
    public init(point: CGFloat, hole: CGFloat, shadow: CGFloat) {
        self.point = point
        self.hole = hole
        self.shadow = shadow
    }
}




