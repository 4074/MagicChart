//
//  ChartAxis.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class ChartAxis: CALayer {
    
    var config: AxisChartAxisConfig = AxisChartAxisConfig()
    var lineLayer: CAShapeLayer?
    var labels = [String]()
    var labelLayer: CATextLayer?
    
    func render() {
        drawLine()
        drawLabel()
    }
    
    func drawLine() {
        if let o = lineLayer {
            o.removeFromSuperlayer()
            lineLayer = nil
        }
    }
    
    func drawLabel() {
        if let o = labelLayer {
            o.removeFromSuperlayer()
            labelLayer = nil
        }
    }
    
    func createLineLayer(origin: CGPoint, end: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: origin)
        path.addLine(to: end)
        
        layer.path = path.cgPath
        layer.strokeColor = config.lineColor.cgColor
        layer.lineWidth = config.lineWidth
        layer.contentsScale = UIScreen.main.scale
        
        return layer
    }
}

class ChartXAxis: ChartAxis {
    
    override func drawLine() {
        super.drawLine()
        
        lineLayer = createLineLayer(origin: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.width, y: 0))
        self.addSublayer(lineLayer!)
    }
    
    override func drawLabel() {
        super.drawLabel()
        
        let itemWidth = frame.width / CGFloat(labels.count - 1)
        let wrapLayer = CATextLayer()
        
        wrapLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: config.labelFont.pointSize
        )
        
        for (index, text) in labels.enumerated() {
            if text.isEmpty {
                continue
            }
            let textLayer = CATextLayer()
            let width: CGFloat = config.labelFont.pointSize * CGFloat(text.count)
            textLayer.frame = CGRect(
                x: itemWidth * CGFloat(index) - width / 2,
                y: config.labelSpacing,
                width: width,
                height: config.labelFont.pointSize
            )
            textLayer.font = config.labelFont
            textLayer.fontSize = config.labelFont.pointSize
            textLayer.foregroundColor = config.labelColor.cgColor
            textLayer.string = text
            textLayer.alignmentMode = "center"
            textLayer.contentsScale = UIScreen.main.scale
            wrapLayer.addSublayer(textLayer)
        }
        
        self.addSublayer(wrapLayer)
        labelLayer = wrapLayer
    }
}

class ChartYAxis: ChartAxis {
    
    override func drawLine() {
        super.drawLine()
        
        lineLayer = createLineLayer(origin: CGPoint(x: frame.width, y: 0), end: CGPoint(x: frame.width, y: frame.height))
        self.addSublayer(lineLayer!)
    }
    
    override func drawLabel() {
        super.drawLabel()
        
        let wrapLayer = CATextLayer()
        
        wrapLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: frame.height
        )
        
        for (index, text) in labels.enumerated() {
            if text.isEmpty {
                continue
            }
            let textLayer = CATextLayer()
            let y = wrapLayer.frame.height - CGFloat(index) * (wrapLayer.frame.height / CGFloat(labels.count - 1)) - (config.labelFont.pointSize / 2)
            textLayer.frame = CGRect(
                x: 0 - config.labelSpacing,
                y: y,
                width: frame.width,
                height: config.labelFont.pointSize
            )
            textLayer.font = config.labelFont
            textLayer.fontSize = config.labelFont.pointSize
            textLayer.foregroundColor = config.labelColor.cgColor
            textLayer.string = index == 0 ? "" : text
            textLayer.alignmentMode = "right"
            textLayer.contentsScale = UIScreen.main.scale
            wrapLayer.addSublayer(textLayer)
        }
        self.addSublayer(wrapLayer)
        labelLayer = wrapLayer
    }
}





