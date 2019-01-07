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
    public var dataLayerInset: UIEdgeInsets = .zero
    
    public var axis: AxisChartAxisConfigGroup!
    
    override public init(frame: CGRect) {
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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleGesture(_ sender: UIPanGestureRecognizer) {
        touchDidUpdate(location: sender.location(in: self))
    }
    
    func touchDidUpdate(location: CGPoint) {}
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
    public var labelInset: UIEdgeInsets = .zero
    public var labelFont: UIFont = UIFont.systemFont(ofSize: 12)
    public var labelColor: UIColor = .lightGray
    public var labelSpacing: CGFloat = 4
    public var labelPosition: AxisChartLabelPosition = .outside
    public var labelAlignment: String = "center"
    public var formatter: NumberFormatter = NumberFormatter()
    
    public var gridVisible: Bool = false
    public var gridWidth: CGFloat = 0.8
    public var gridColor: UIColor = .lightGray
    
    public var range: AxisChartAxisRange = AxisChartAxisRange(
        minimum: AxisChartAxisRangeItem(type: .manual, value: 0),
        maximum: AxisChartAxisRangeItem(type: .auto, value: nil)
    )
    public var reverse: Bool = false
    
    var frame: CGRect = .zero
    var layer: ChartAxisLayer? = nil
}

public struct AxisChartAxisRange {
    public var minimum: AxisChartAxisRangeItem
    public var maximum: AxisChartAxisRangeItem
    
    public init(minimum: AxisChartAxisRangeItem, maximum: AxisChartAxisRangeItem) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

public struct AxisChartAxisRangeItem {
    public var type: MagicChartAxisRangeType
    public var value: Double?
    
    public init(type: MagicChartAxisRangeType, value: Double?) {
        self.type = type
        self.value = value
    }
}

public enum AxisChartLabelPosition {
    case inside
    case outside
}

public enum AxisChartAxisDirection {
    case x
    case y
}
