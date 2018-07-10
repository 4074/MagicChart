//
//  BaseChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class AxisChart: UIView {

    let screenScale = UIScreen.main.scale
    var colors: [UIColor] = [.green, .blue, .orange, .red]
    var rendering = false
    var animation = true
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?

    var chartLayer: CALayer?
    var dataLayer: CALayer?
    
    var inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    var axisConfig: (x: AxisChartAxisConfig, y: AxisChartAxisConfig)!
    var axisFrame: (x: CGRect, y: CGRect) = (.zero, .zero)
    
    var axisLayer: (x: ChartXAxis?, y: ChartYAxis?) = (nil, nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xConfig = AxisChartAxisConfig()
        let yConfig = AxisChartAxisConfig()
        yConfig.labelAlignment = "right"
        
        axisConfig = (xConfig, yConfig)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    func touchDidUpdate(location: CGPoint) {
        
    }
}

public class AxisChartAxisConfig {
    var direction: AxisChartAxisDirection = .x
    var lineWidth: CGFloat = 0.8
    var lineColor: UIColor = .lightGray
    
    var labelCount: Int = 4
    var labelFont: UIFont = UIFont.systemFont(ofSize: 12)
    var labelColor: UIColor = .lightGray
    var labelSpacing: CGFloat = 4
    var labelPosition: AxisChartLabelPosition = .outside
    var labelAlignment: CATextLayerAlignmentMode = "center"
    var formatter: NumberFormatter = NumberFormatter()
}

public enum AxisChartLabelPosition {
    case inside
    case outside
}

public enum AxisChartAxisDirection {
    case x
    case y
}
