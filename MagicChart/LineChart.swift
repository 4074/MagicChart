//
//  LineChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/1/11.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class LineChart: UIView {

    var dataSet: [LineChartDataSet] = [] {
        didSet {
            render()
        }
    }
    var dataSetLayer: [CAShapeLayer] = []
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?
    
    var colors: [UIColor] = [.green, .blue, .orange, .red]
    
    var origin: CGPoint = CGPoint(x: 0, y: 0)
    var inset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var axisLayer: (x: CAShapeLayer, y: CAShapeLayer)?
    var axisLineWidth: (x: CGFloat, y: CGFloat) = (1, 1)
    var axisLineColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        origin = CGPoint(x: inset.left, y: self.frame.size.height - inset.bottom)
        range = getYAxisRange()
        drawAxisLine()
        drawSetLine()
    }
    
    func drawSetLine() {
        guard let range = self.range else {
            return
        }
        
        let size = self.frame.size
        
        for (index, set) in dataSet.enumerated() {
            let layer = CAShapeLayer()
            layer.frame = CGRect(
                x: inset.left,
                y: inset.top,
                width: size.width - inset.left - inset.right,
                height: size.height - inset.top - inset.bottom
            )
            
            let path = UIBezierPath()
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.lineWidth = set.lineWidth
            
            for (i, v) in set.value.enumerated() {
                let x = (Double(i) / Double(set.value.count)) * Double(layer.frame.width)
                let y = (1 - (v / (range.maximum - range.minimum))) * Double(layer.frame.height)
                let point = CGPoint(x: x, y: y)
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            layer.path = path.cgPath
            layer.strokeColor = (set.lineColor ?? colors[index % colors.count]).cgColor
            layer.fillColor = nil
            
            self.layer.addSublayer(layer)
        }
        
    }
    
    func drawAxisLine() {
        let size = self.frame.size
        
        let xAxisLayer = createAxisLineLayer(size, end: CGPoint(x: size.width - inset.right, y: origin.y), width: axisLineWidth.x, color: axisLineColor.x)
        self.layer.addSublayer(xAxisLayer)
        
        let yAxisLayer = createAxisLineLayer(size, end: CGPoint(x: origin.x, y: inset.top), width: axisLineWidth.x, color: axisLineColor.x)
        self.layer.addSublayer(yAxisLayer)
        
        axisLayer = (xAxisLayer, yAxisLayer)
    }
    
    func createAxisLineLayer(_ size: CGSize, end: CGPoint, width: CGFloat, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.lineWidth = width
        path.move(to: origin)
        path.addLine(to: end)
        
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        
        return layer
    }
}

extension LineChart {
    
    func getYAxisRange() -> (minimum: Double, maximum: Double)? {
        var minimum: Double = Double.infinity
        var maximum: Double = -Double.infinity
        
        if rangeType.minimum == .auto || rangeType.maximum == .auto {
            let rangeCalculated = calculateYAxisRange()
            if rangeType.minimum == .auto {
                minimum = rangeCalculated.minimum
            }
            if rangeType.maximum == .auto {
                maximum = rangeCalculated.maximum
            }
        }
        
        if rangeType.minimum == .zero {
            minimum = 0
        }
        
        if let rangeManual = range {
            if rangeType.minimum == .manual {
                minimum = rangeManual.minimum
            }
            if rangeType.maximum == .manual {
                maximum = rangeManual.maximum
            }
        }
        
        return minimum <= maximum ? (minimum, maximum) : nil
    }
    
    func calculateYAxisRange() -> (minimum: Double, maximum: Double) {
        var minimum: Double = Double.infinity
        var maximum: Double = -Double.infinity
        
        for set in dataSet {
            if let m = set.value.min() {
                minimum = min(m, minimum)
            }
            if let m = set.value.max() {
                maximum = max(m, maximum)
            }
        }
        
        return (minimum, maximum)
    }
}

class LineChartDataSet {
    var value = [Double]()
    var label = [String]()
    var lineWidth: CGFloat = 1
    var lineColor: UIColor?
}

enum MagicChartAxisRangeType {
    case auto
    case zero
    case manual
}


