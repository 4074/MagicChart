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
    var dataSetLayer: [(set: CAShapeLayer, line: CAShapeLayer, mask: CAShapeLayer?)] = []
    var dataPointLayer: [(layer: CAShapeLayer, subs: [CAShapeLayer])?] = []
    var dataPoints: [[CGPoint]] = []
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?
    
    var colors: [UIColor] = [.green, .blue, .orange, .red]
    var duration: TimeInterval = 1
    
    var origin: CGPoint = CGPoint(x: 0, y: 0)
    var inset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    var layerFrame: CGRect = .zero
    
    var axisLayer: (x: ChartXAxis?, y: ChartYAxis?) = (nil, nil)
    var axisLineWidth: (x: CGFloat, y: CGFloat) = (0.2, 0.2)
    var axisLineColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    
    var axisLabelCount: (x: Int, y: Int) = (4, 4)
    var axisLabelFont: (x: UIFont, y: UIFont) = (UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12))
    var axisLabelColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    
    var selectedIndex: Int? = nil
    var selectedLayer: CAShapeLayer?
    var selectedLineWidth: CGFloat = 1
    var selectedLineColor: UIColor = .purple
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let index = ChartUtils.computeSelectedIndex(point: location, frame: layerFrame, inset: inset, count: dataSource.label.count)
            if index != selectedIndex {
                selectedIndex = index
                drawSelected()
            }
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let index = ChartUtils.computeSelectedIndex(point: location, frame: layerFrame, inset: inset, count: dataSource.label.count)
            if index != selectedIndex {
                selectedIndex = index
                drawSelected()
            }
            break
        }
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
        axisLayer.x?.removeFromSuperlayer()
        axisLayer.y?.removeFromSuperlayer()
        axisLayer = (nil, nil)
        
        selectedLayer?.removeFromSuperlayer()
        
        for group in dataSetLayer {
            group.line.removeFromSuperlayer()
        }
        
        for group in dataPointLayer {
            if let p = group {
                p.layer.removeFromSuperlayer()
            }
        }
        
        dataSetLayer.removeAll()
        dataPointLayer.removeAll()
    }
    
    func drawSetLine() {
        guard let range = self.range else {
            return
        }
        
        CATransaction.begin()
        
        for (index, set) in dataSource.sets.enumerated() {
            let setLayer = CAShapeLayer()
            setLayer.frame = layerFrame
            
            let lineLayer = CAShapeLayer()
            let color = (set.lineColor ?? colors[index % colors.count])
            var points = [CGPoint]()
            
            lineLayer.frame = setLayer.bounds
            for (i, k) in dataSource.label.enumerated() {
                if let v = set.value[k] {
                    let x = (Double(i) / Double(set.value.count - 1)) * Double(layerFrame.width)
                    let y = (1 - (v / (range.maximum - range.minimum))) * Double(layerFrame.height)
                    let point = CGPoint(x: x, y: y)
                    
                    points.append(point)
                }
            }
            
            for (i, p) in points.enumerated() {
                
                if i == 0 {
                } else {
                    let path = UIBezierPath()
                    path.lineCapStyle = .round
                    path.lineJoinStyle = .round
                    
                    path.move(to: points[i - 1])
                    
                    
                    if set.lineStyle == .curve {
                        let controlPoints = computeControlPoint(points: points, index: i - 1)
                        path.addCurve(to: p, controlPoint1: controlPoints.a, controlPoint2: controlPoints.b)
                    } else {
                        path.addLine(to: p)
                    }
                    
                    let pathLayer = CAShapeLayer()
                    pathLayer.path = path.cgPath
                    pathLayer.strokeColor = color.cgColor
                    pathLayer.lineWidth = set.lineWidth
                    pathLayer.fillColor = UIColor.clear.cgColor
                    
                    if set.lineDashPattern.count > i - 1 && !set.lineDashPattern[i - 1].isEmpty {
                        pathLayer.lineDashPattern = set.lineDashPattern[i - 1] as [NSNumber]
                        pathLayer.contentsScale = UIScreen.main.scale
                    }
                    
                    lineLayer.addSublayer(pathLayer)
                }
            }

            
            setLayer.addSublayer(lineLayer)
            
            let maskLayer = createAnimationMask(layer: lineLayer)
            lineLayer.mask = maskLayer
            
            dataPoints.append(points)
            dataSetLayer.append((setLayer, lineLayer, maskLayer))
            
            if let shape = set.pointShape {
                let pointLayer = createPointLayer(setLayer.bounds, points: points, radius: set.pointRadius, shape: shape, color: color)
                setLayer.addSublayer(pointLayer.layer)
                dataPointLayer.append(pointLayer)
                addAnimationToPoints(index: index)
            } else {
                dataPointLayer.append(nil)
            }
            
            self.layer.addSublayer(setLayer)
        }
        
        CATransaction.commit()
    }
    
    func addAnimationToPoints(index: Int) {
        if let mask = dataSetLayer[index].mask, let layers = dataPointLayer[index]?.subs {
            let animator = PointAnimator(
                source: mask,
                duration: duration,
                points: dataPoints[index],
                layers: layers
            )
            animator.start()
        }
    }
    
    func createAnimationMask(layer: CAShapeLayer) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: layer.bounds).cgPath
        maskLayer.frame = layer.bounds
        addAnimationToLayer(maskLayer, duration: duration)
        
        return maskLayer
    }
    
    func computeControlPoint(points: [CGPoint], index: Int) -> (a: CGPoint, b: CGPoint) {
        let last = points[max(0, index - 1)]
        let next = points[min(points.count - 1, index + 1)]
        let next2 = points[min(points.count - 1, index + 2)]
        let current = points[index]
        
        let a = CGPoint(
            x: current.x + (next.x - last.x) / 4,
            y: current.y + (next.y - last.y) / 4
        )
        let b = CGPoint(
            x: next.x - (next2.x - current.x) / 4,
            y: next.y - (next2.y - current.y) / 4
        )
        
        return (a, b)
    }
    
    func drawAxisLine() {
        let xAxis = ChartXAxis()
        xAxis.frame = CGRect(x: inset.left, y: layerFrame.height + inset.top, width: layerFrame.width, height: 30)
        xAxis.labels = ChartUtils.selectStrings(source: dataSource.label, count: axisLabelCount.x, force: false)
        xAxis.lineWidth = axisLineWidth.x
        xAxis.lineColor = axisLineColor.x
        xAxis.labelFont = axisLabelFont.x
        xAxis.labelColor = axisLabelColor.x
        xAxis.render()
        self.layer.addSublayer(xAxis)
        
        let yAxis = ChartYAxis()
        yAxis.frame = CGRect(x: 0, y: inset.top, width: inset.left, height: layerFrame.height)
        if let range = range {
            yAxis.labels = ChartUtils.selectNumbers(min: range.minimum, max: range.maximum, count: axisLabelCount.y).map { (v) -> String in
                return self.getYAxisLabelTextFromValue(value: v)
            }
        }
        yAxis.lineWidth = axisLineWidth.y
        yAxis.lineColor = axisLineColor.y
        yAxis.labelFont = axisLabelFont.y
        yAxis.labelColor = axisLabelColor.y
        yAxis.render()
        self.layer.addSublayer(yAxis)
        
        axisLayer = (xAxis, yAxis)
    }
    
    func getYAxisLabelTextFromValue(value: Double) -> String {
        return String(Int(value))
    }
    
    func drawSelected() {
        guard let index = selectedIndex else {
            return
        }
        
        if selectedLayer == nil {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            
            path.lineWidth = selectedLineWidth
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: layerFrame.height))
            
            layer.path = path.cgPath
            layer.strokeColor = selectedLineColor.cgColor
            
            self.layer.addSublayer(layer)
            selectedLayer = layer
        }
        
        let x = layerFrame.width / CGFloat(dataSource.label.count - 1) * CGFloat(index)
        selectedLayer?.frame = CGRect(x: x + layerFrame.minX, y: layerFrame.minY, width: selectedLineWidth, height: layerFrame.height)
    }
}

extension LineChart {
    
    func getYAxisRange() -> (minimum: Double, maximum: Double)? {
        var minimum: Double = Double.infinity
        var maximum: Double = -Double.infinity
        
        if rangeType.minimum == .auto || rangeType.maximum == .auto {
            let values = dataSource.sets.map { (set) -> [Double] in
                return Array(set.value.values)
            }
            let rangeCalculated = ChartUtils.getNumberRange(source: values)
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
    
    func createPointLayer(_ frame: CGRect, points: [CGPoint], radius: CGFloat, shape: MagicChartPointShape, color: UIColor) -> (layer: CAShapeLayer, subs: [CAShapeLayer]) {
        let layer = CAShapeLayer()
        var subs: [CAShapeLayer] = []
        
        layer.frame = frame
        
        for point in points {
            
            switch shape {
            case .circle:
                let circle = ChartUtils.createCircleShape(center: point, radius: radius, color: color)
                subs.append(circle)
                layer.addSublayer(circle)
            case .square:
                let square = ChartUtils.createSquareShape(center: point, radius: radius, color: color)
                subs.append(square)
                layer.addSublayer(square)
            default:
                break
            }
        }
        
        return (layer, subs)
    }
    
    func addAnimationToLayer(_ layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = UIBezierPath(rect: CGRect(x: layer.bounds.minX, y: layer.bounds.minY, width: 0, height: layer.bounds.height)).cgPath
        animation.toValue = layer.path
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.add(animation, forKey: "path")
    }
    
    func createMaskLayer(_ layer: CAShapeLayer) -> CGPath {
        let path = UIBezierPath(rect: layer.bounds)
        return path.cgPath
    }
    
    func createDataSet(_ label: [String], value: [Double], style: ((_ :LineChartDataSet) -> Void)?) -> LineChartDataSet {
        let set = LineChartDataSet()
        for (index, key) in label.enumerated() {
            set.value[key] = value[index]
        }
        
        if let style = style {
            style(set)
        }
        
        return set
    }
    
    func createDataSets(_ label: [String], groups: [[Double]], style: ((_ :LineChartDataSet, _: Int) -> Void)?) -> [LineChartDataSet] {
        var sets = [LineChartDataSet]()
        
        for (index, group) in groups.enumerated() {
            let set = self.createDataSet(label, value: group, style: nil)
            if let style = style {
                style(set, index)
            }
            sets.append(set)
        }
        
        return sets
    }
}


