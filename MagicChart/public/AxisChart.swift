//
//  BaseChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

open class AxisChart: UIView {

    let screenScale = UIScreen.main.scale
    var rendering = false
    
    public var colors: [UIColor] = [.green, .blue, .orange, .red]
    public var animation = true

    public var chartLayer: CALayer?
    public var dataLayer: CALayer?
    
    public var inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    public var axis: AxisChartAxisConfigGroup!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xConfig = AxisChartAxisConfig()
        let yLeftConfig = AxisChartAxisConfig()
        let yRightConfig = AxisChartAxisConfig()
        
        yLeftConfig.position = .left
        yLeftConfig.labelAlignment = "left"
        
        yRightConfig.position = .right
        yRightConfig.labelAlignment = "right"
        
        axis = AxisChartAxisConfigGroup(
            x: xConfig,
            y: AxisChartAxisConfigGroupY(left: yLeftConfig, right: yRightConfig)
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    func touchDidUpdate(location: CGPoint) {
        
    }
}

public struct AxisChartAxisConfigGroup {
    public var x: AxisChartAxisConfig
    public var y: AxisChartAxisConfigGroupY
}

public struct AxisChartAxisConfigGroupY {
    public var left: AxisChartAxisConfig
    public var right: AxisChartAxisConfig
}

public class AxisChartAxisConfig {
    public var direction: AxisChartAxisDirection = .x
    public var position: AxisChartAxisPosition = .bottom
    public var lineWidth: CGFloat = 0.8
    public var lineColor: UIColor = .lightGray
    
    public var labelCount: Int = 4
    public var labelFont: UIFont = UIFont.systemFont(ofSize: 12)
    public var labelColor: UIColor = .lightGray
    public var labelSpacing: CGFloat = 4
    public var labelPosition: AxisChartLabelPosition = .outside
    public var labelAlignment: String = "center"
    public var formatter: NumberFormatter = NumberFormatter()
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?
    var frame: CGRect = .zero
    var layer: ChartAxisLayer? = nil
}

public enum AxisChartLabelPosition {
    case inside
    case outside
}

public enum AxisChartAxisDirection {
    case x
    case y
}