//
//  LineChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/1/11.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class LineChart: UIView {
    
    var dataSource: LineChartDataSource = LineChartDataSource() {
        didSet {
            self.reset()
            self.render()
        }
    }
    var dataSetLayer: [(line: CAShapeLayer, point: CAShapeLayer?)] = []
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?
    
    var colors: [UIColor] = [.green, .blue, .orange, .red]
    
    var origin: CGPoint = CGPoint(x: 0, y: 0)
    var inset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    var layerFrame: CGRect = .zero
    
    var axisLayer: (x: CAShapeLayer, y: CAShapeLayer)?
    var axisLineWidth: (x: CGFloat, y: CGFloat) = (1, 1)
    var axisLineColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    
    var graphicsContext: CGContext?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        origin = CGPoint(x: 0, y: self.frame.size.height - inset.top - inset.bottom)
        range = getYAxisRange()
        layerFrame = CGRect(
            x: inset.left,
            y: inset.top,
            width: self.frame.size.width - inset.left - inset.right,
            height: self.frame.size.height - inset.top - inset.bottom
        )
        
        drawAxisLine()
        drawSetLine()
    }
    
    func reset() {
        if let axisLayer = self.axisLayer {
            axisLayer.x.removeFromSuperlayer()
            axisLayer.y.removeFromSuperlayer()
            self.axisLayer = nil
        }
        
        for group in dataSetLayer {
            group.line.removeFromSuperlayer()
            if let point = group.point {
                point.removeFromSuperlayer()
            }
        }
        dataSetLayer.removeAll()
    }
    
    func drawSetLine() {
        guard let range = self.range else {
            return
        }
        
        CATransaction.begin()
        
        for (index, set) in dataSource.sets.enumerated() {
            let lineLayer = CAShapeLayer()
            let color = (set.lineColor ?? colors[index % colors.count])
            var points = [CGPoint]()
            
            lineLayer.frame = layerFrame
            
            let path = UIBezierPath()
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            
            for (i, k) in dataSource.label.enumerated() {
                if let v = set.value[k] {
                    let x = (Double(i) / Double(set.value.count - 1)) * Double(layerFrame.width)
                    let y = (1 - (v / (range.maximum - range.minimum))) * Double(layerFrame.height)
                    let point = CGPoint(x: x, y: y)
                    
                    if i == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                    points.append(point)
                }
            }
            
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = color.cgColor
            lineLayer.lineWidth = set.lineWidth
            lineLayer.fillColor = UIColor.clear.cgColor
            addAnimationToLayer(lineLayer)
            self.layer.addSublayer(lineLayer)
            
            if let shape = set.pointShape {
                let pointLayer = createPointLayer(layerFrame, points: points, radius: set.pointRadius, shape: shape, color: color)
                addAnimationToLayer(pointLayer, duration: 1.2)
                self.layer.addSublayer(pointLayer)
                dataSetLayer.append((lineLayer, pointLayer))
            } else {
                dataSetLayer.append((lineLayer, nil))
            }
        }
        
        CATransaction.commit()
    }
    
    func drawAxisLine() {
        
        let xAxisLayer = createAxisLineLayer(end: CGPoint(x: layerFrame.width, y: layerFrame.height), width: axisLineWidth.x, color: axisLineColor.x)
        self.layer.addSublayer(xAxisLayer)
        
        let yAxisLayer = createAxisLineLayer(end: CGPoint(x: 0, y: 0), width: axisLineWidth.x, color: axisLineColor.x)
        self.layer.addSublayer(yAxisLayer)
        
        if !dataSource.label.isEmpty {
            let itemWidth = layerFrame.width / (CGFloat(dataSource.label.count) - 1)
            for (index, text) in dataSource.label.enumerated() {
                let xAxisTextLayer = CATextLayer()
                let width: CGFloat = 12
                xAxisTextLayer.frame = CGRect(
                    x: inset.left + itemWidth * CGFloat(index) - width / 2,
                    y: inset.top + layerFrame.height + 4,
                    width: width,
                    height: 12
                )
                xAxisTextLayer.font = UIFont.systemFont(ofSize: 12)
                xAxisTextLayer.fontSize = 12
                xAxisTextLayer.foregroundColor = UIColor.lightGray.cgColor
                xAxisTextLayer.string = text
                self.layer.addSublayer(xAxisTextLayer)
            }
        }
        
        axisLayer = (xAxisLayer, yAxisLayer)
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
        
        for set in dataSource.sets {
            if let m = set.value.values.min() {
                minimum = min(m, minimum)
            }
            if let m = set.value.values.max() {
                maximum = max(m, maximum)
            }
        }
        
        return (minimum, maximum)
    }
    
    func createAxisLineLayer(end: CGPoint, width: CGFloat, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = layerFrame
        
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
    
    func createPointLayer(_ frame: CGRect, points: [CGPoint], radius: CGFloat, shape: MagicChartPointShape, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        layer.frame = frame
        
        for point in points {
            switch shape {
            case .circle:
                path.move(to: point)
                path.addArc(withCenter: point, radius: radius/2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                layer.lineWidth = radius
            case .square:
                path.move(to: point)
                let num = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
                let x_start = point.x - num
                let x_end = point.x + num
                
                path.move(to: CGPoint(x: x_start, y: point.y))
                path.addLine(to: CGPoint(x: x_end, y: point.y))
                
                layer.lineWidth = num * 2
            default:
                break
            }
        }
        
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }
    
    func addAnimationToLayer(_ layer: CAShapeLayer, duration: CFTimeInterval = 1) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layer.add(animation, forKey: "strokeEnd")
    }
    
    func createDataSet(_ label: [String], groups: [[Double]], style: ((_ :LineChartDataSet, _: Int) -> Void)?) -> [LineChartDataSet] {
        var sets = [LineChartDataSet]()
        
        for (index, group) in groups.enumerated() {
            let set = LineChartDataSet()
            if group.count != label.count {
                continue
            }
            for (index, key) in label.enumerated() {
                set.value[key] = group[index]
            }
            
            if let style = style {
                style(set, index)
            }
            
            sets.append(set)
        }
        
        return sets
    }
}

class LineChartDataSource {
    var label = [String]()
    var sets = [LineChartDataSet]()
}

class LineChartDataSet {
    var value = [String: Double]()
    var lineWidth: CGFloat = 1
    var lineColor: UIColor?
    var pointShape: MagicChartPointShape? = nil
    var pointRadius: CGFloat = 4
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


