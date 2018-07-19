//
//  LineChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/1/11.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

open class LineChart: AxisChart {
    
    var dataSource: LineChartDataSource = LineChartDataSource() {
        didSet {
            self.reset()
            self.render()
        }
    }
    var dataSetLayer: [(set: CAShapeLayer, line: CAShapeLayer, mask: CAShapeLayer?)] = []
    var dataPointLayer: [(layer: CAShapeLayer, subs: [LineChartCirclePoint])?] = []
    var dataPoints: [[CGPoint]] = []
    private var dataPointsCache: [[CGPoint]] = []
    
    var duration: TimeInterval = 1
    
    var selectedIndex: Int? = nil
    var selectedLayer: CAShapeLayer?
    var selectedLineWidth: CGFloat = 1
    var selectedLineColor: UIColor = .purple
    
    var delegate: LineChartDelegate?
    
    override func touchDidUpdate(location: CGPoint) {
        if let dataLayer = self.dataLayer, !rendering {
            let frameInset = UIEdgeInsets(top: inset.top, left: inset.left + self.frame.width - dataLayer.frame.width, bottom: inset.bottom, right: inset.right)
            let index = ChartUtils.computeSelectedIndex(point: location, frame: dataLayer.frame, inset: frameInset, count: dataSource.label.count)
            handleDidSelect(index: index)
        }
    }
    
    func render() {
        rendering = true
        range = getYAxisRange()
        
        chartLayer = CALayer()
        chartLayer!.frame = CGRect(
            x: inset.left,
            y: inset.top,
            width: self.frame.size.width - inset.left - inset.right,
            height: self.frame.size.height - inset.top - inset.bottom
        )
        self.layer.addSublayer(chartLayer!)
        
        let xAxisHeight = getXAxisHeight()
        let yAxisWidth = getYAxisWidth()
        
        let insetWidth = axisConfig.y.labelPosition == .outside ? yAxisWidth : 0
        let insetHeight = axisConfig.x.labelPosition == .outside ? xAxisHeight : 0
        
        dataLayer = CALayer()
        dataLayer!.frame = CGRect(
            x: insetWidth,
            y: 0,
            width: chartLayer!.frame.width - insetWidth,
            height: chartLayer!.frame.height - insetHeight
        )
        chartLayer?.addSublayer(dataLayer!)
        
        axisFrame = (
            CGRect(x: insetWidth, y: dataLayer!.frame.height, width: dataLayer!.frame.width, height: xAxisHeight),
            CGRect(x: 0, y: 0, width: yAxisWidth, height: dataLayer!.frame.height)
        )
        
        drawAxisLine()
        drawSetLine()
        
        if !animation {
            handleDidRender()
        }
    }
    
    func reset() {
        axisLayer.x?.removeFromSuperlayer()
        axisLayer.y?.removeFromSuperlayer()
        axisLayer = (nil, nil)
        
        selectedIndex = nil
        selectedLayer?.removeFromSuperlayer()
        selectedLayer = nil
        
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
        
        for (index, set) in dataSource.sets.enumerated() {
            let setLayer = CAShapeLayer()
            setLayer.frame = CGRect(origin: .zero, size: dataLayer!.frame.size)
            
            let lineLayer = CAShapeLayer()
            let color = (set.lineColor ?? colors[index % colors.count])
            var points = [CGPoint]()
            
            lineLayer.frame = setLayer.bounds
            for (i, k) in dataSource.label.enumerated() {
                if let v = set.value[k] {
                    let x = (Double(i) / Double(set.value.count - 1)) * Double(setLayer.frame.width)
                    let y = (1 - (v / (range.maximum - range.minimum))) * Double(setLayer.frame.height)
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
                    pathLayer.contentsScale = screenScale
                    pathLayer.fillColor = UIColor.clear.cgColor
                    
                    if set.lineDashPattern.count > i - 1 && !set.lineDashPattern[i - 1].isEmpty {
                        pathLayer.lineDashPattern = set.lineDashPattern[i - 1] as [NSNumber]
                        pathLayer.contentsScale = screenScale
                    }
                    
                    lineLayer.addSublayer(pathLayer)
                }
            }

            let innerLayer = CAShapeLayer()
            innerLayer.frame = setLayer.bounds
            innerLayer.addSublayer(lineLayer)
            
            setLayer.addSublayer(innerLayer)
            dataPoints.append(points)

            if animation {
                let maskLayer = createAnimationMask(layer: lineLayer)
                lineLayer.mask = maskLayer
                dataSetLayer.append((setLayer, lineLayer, maskLayer))
            } else {
                dataSetLayer.append((setLayer, lineLayer, nil))
            }
            
            if let pointConfig = set.pointConfig {
                let pointLayer = createPointLayer(frame: setLayer.bounds, points: points, config: pointConfig)
                setLayer.addSublayer(pointLayer.layer)
                dataPointLayer.append(pointLayer)
                
                // TODO: innerLayer mask with animation
//                let m = CAShapeLayer()
//                let path = CGMutablePath()
//                path.addRect(innerLayer.bounds)
//
//                let ps = createPointMaskPath(points: points, radius: set.pointRadius, shape: shape)
//                for p in ps {
//                    path.addPath(p)
//                }
//                
//                m.fillRule = kCAFillRuleEvenOdd
//                m.path = path
//                innerLayer.mask = m
                
                if animation {
                    addAnimationToPoints(index: index)
                }
            } else {
                dataPointLayer.append(nil)
            }
            
            dataLayer?.addSublayer(setLayer)
        }
    }
    
    func addAnimationToPoints(index: Int) {
        if let mask = dataSetLayer[index].mask, let layers = dataPointLayer[index]?.subs {
            addAnimationToPoints(mask: mask, layers: layers, points: dataPoints[index])
        }
    }
    
    func addAnimationToPoints(mask: CAShapeLayer, layers: [CAShapeLayer], points: [CGPoint]) {
        let animator = PointAnimator(
            source: mask,
            duration: duration,
            points: points,
            layers: layers
        )
        animator.setCompletionBlock {
            self.handleDidRender()
        }
        animator.start()
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
        xAxis.frame = axisFrame.x
        xAxis.labels = ChartUtils.selectStrings(source: dataSource.label, count: axisConfig.x.labelCount, force: false)
        xAxis.config = axisConfig.x
        xAxis.render()
        chartLayer?.addSublayer(xAxis)
        
        let yAxis = ChartYAxis()
        yAxis.frame = axisFrame.y
        if let range = range {
            yAxis.labels = ChartUtils.selectNumbers(min: range.minimum, max: range.maximum, count: axisConfig.y.labelCount).map { (v) -> String in
                return self.getYAxisLabelTextFromValue(value: v)
            }
        }
        yAxis.config = axisConfig.y
        yAxis.render()
        chartLayer?.addSublayer(yAxis)
        
        axisLayer = (xAxis, yAxis)
    }
    
    func getYAxisLabelTextFromValue(value: Double) -> String {
        return axisConfig.y.formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func handleDidRender() {
        rendering = false
        if let d = self.delegate {
            d.chartView(self, didDraw: true)
        }
    }
    
    func setSelected(index: Int) {
        handleDidSelect(index: index)
    }
    
    func handleDidSelect(index: Int) {
        if index < dataSource.label.count && index != selectedIndex {
            selectedIndex = index
            if let d = delegate {
                d.chartView(self, didSelect: index)
            }
            drawSelected()
        }
    }
    
    func drawSelected() {
        guard let index = selectedIndex else {
            return
        }
        let x = dataLayer!.frame.width / CGFloat(dataSource.label.count - 1) * CGFloat(index)
        let frame = CGRect(x: x, y: 0, width: selectedLineWidth, height: dataLayer!.frame.height)
        
        if selectedLayer == nil {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            
            layer.frame = frame
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            
            path.lineWidth = selectedLineWidth
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: dataLayer!.frame.height))
            
            layer.path = path.cgPath
            layer.strokeColor = selectedLineColor.cgColor
            
            if let d = delegate {
                d.chartView(self, styleSelectedLayer: layer)
            }
            
            dataLayer!.addSublayer(layer)
            selectedLayer = layer
        } else {
            selectedLayer?.frame = frame
        }
        
        drawSelectedPoint(index: index)
    }
    
    func drawSelectedPoint(index: Int) {
        for group in dataPointLayer {
            if let subs = group?.subs {
                for (i, p) in subs.enumerated() {
                    p.active = i == index
                }
            }
        }
    }
}

extension LineChart {
    
    func getXAxisHeight() -> CGFloat {
        return axisConfig.x.labelFont.pointSize + axisConfig.x.labelSpacing
    }
    
    func getYAxisWidth() -> CGFloat {
        var width: CGFloat = 0
        if let range = range {
            let labels = ChartUtils.selectNumbers(min: range.minimum, max: range.maximum, count: axisConfig.y.labelCount).map { (v) -> String in
                return self.getYAxisLabelTextFromValue(value: v)
            }
            
            width = ChartUtils.getMaxStringWidth(strings: labels, font: axisConfig.y.labelFont)
        }
        return width + axisConfig.y.labelSpacing
    }
    
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
                maximum = ChartUtils.getNestNumber(source: rangeCalculated.maximum)
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
    
    func createPointLayer(frame: CGRect, points: [CGPoint], config: LineChartPointConfig) -> (layer: CAShapeLayer, subs: [LineChartCirclePoint]) {
        let layer = CAShapeLayer()
        var subs: [LineChartCirclePoint] = []
        
        layer.frame = frame
        
        for point in points {
            let pointLayer = LineChartCirclePoint(center: point, config: config)
            subs.append(pointLayer)
            layer.addSublayer(pointLayer)
        }
        
        return (layer, subs)
    }
    
    func createPointMaskPath(points: [CGPoint], radius: CGFloat, shape: MagicChartPointShape) -> [CGPath] {
        var paths = [CGPath]()
        
        for point in points {
            switch shape {
            case .circle:
                let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                paths.append(path.cgPath)
            case .square:
                let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                paths.append(path.cgPath)
            default:
                break
            }
        }
        
        return paths
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

public protocol LineChartDelegate: class {
    func chartView(_ chartView: LineChart, didDraw: Bool)
    
    func chartView(_ chartView: LineChart, didSelect index: Int)
    
    func chartView(_ chartView: LineChart, styleSelectedLayer layer: CAShapeLayer)
}

extension LineChartDelegate {
    func chartView(_ chartView: LineChart, didDraw: Bool) {
    }
    
    func chartView(_ chartView: LineChart, didSelect index: Int) {
    }
    
    func chartView(_ chartView: LineChart, styleSelectedLayer layer: CAShapeLayer) {
    }
}
