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
    var colors: [UIColor] = [.green, .blue, .orange, .red]
    var rendering = false
    var animation = true

    var chartLayer: CALayer?
    var dataLayer: CALayer?
    
    var inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    var axisConfig: AxisChartAxisConfigGroup!
    
    var axisLayer: (x: ChartXAxis?, yLeft: ChartYAxis?, yRight: ChartYAxis?) = (nil, nil, nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xConfig = AxisChartAxisConfig()
        let yLeftConfig = AxisChartAxisConfig()
        let yRightConfig = AxisChartAxisConfig()
        
        yLeftConfig.position = .left
        yLeftConfig.labelAlignment = "left"
        
        yRightConfig.position = .right
        yRightConfig.labelAlignment = "right"
        
        axisConfig = AxisChartAxisConfigGroup(
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
    var x: AxisChartAxisConfig
    var y: AxisChartAxisConfigGroupY
}

public struct AxisChartAxisConfigGroupY {
    var left: AxisChartAxisConfig
    var right: AxisChartAxisConfig
}

public class AxisChartAxisConfig {
    var direction: AxisChartAxisDirection = .x
    var position: AxisChartAxisPosition = .bottom
    var lineWidth: CGFloat = 0.8
    var lineColor: UIColor = .lightGray
    
    var labelCount: Int = 4
    var labelFont: UIFont = UIFont.systemFont(ofSize: 12)
    var labelColor: UIColor = .lightGray
    var labelSpacing: CGFloat = 4
    var labelPosition: AxisChartLabelPosition = .outside
    var labelAlignment: String = "center"
    var formatter: NumberFormatter = NumberFormatter()
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?
    var frame: CGRect = .zero
}

public enum AxisChartLabelPosition {
    case inside
    case outside
}

public enum AxisChartAxisDirection {
    case x
    case y
}
