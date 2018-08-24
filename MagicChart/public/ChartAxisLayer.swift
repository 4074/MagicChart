//
//  ChartAxisLayer.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class ChartAxisLayer: CALayer {
    
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
        layer.masksToBounds = true
        
        return layer
    }
}

public class ChartXAxisLayer: ChartAxisLayer {
    
    override func drawLine() {
        super.drawLine()
        
        lineLayer = createLineLayer(origin: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.width, y: 0))
        self.addSublayer(lineLayer!)
    }
    
    override func drawLabel() {
        super.drawLabel()
        
        let wrapLayer = CATextLayer()
        wrapLayer.frame = CGRect(
            x: config.labelInset.left,
            y: 0,
            width: frame.width - config.labelInset.left - config.labelInset.right,
            height: config.labelFont.pointSize
        )
        
        let itemWidth = wrapLayer.frame.width / CGFloat(max(1, labels.count - 1))
        
        for (index, text) in labels.enumerated() {
            if text.isEmpty {
                continue
            }
            let textLayer = CATextLayer()
            let width: CGFloat = ChartUtils.getStringWidth(string: text, font: config.labelFont)
            let centerX = labels.count == 1 ? wrapLayer.frame.width/2 : itemWidth * CGFloat(index)
            var x = centerX - width/2
            
            if config.labelInset == .zero {
                if index == 0 {
                    x = centerX
                } else if index == labels.count - 1 {
                    x = centerX - width
                }
            }
            
            textLayer.frame = CGRect(
                x: x,
                y: config.labelSpacing,
                width: width,
                height: config.labelFont.pointSize + 4
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

public class ChartYAxisLayer: ChartAxisLayer {
    
    override func drawLine() {
        super.drawLine()
        
        lineLayer = createLineLayer(origin: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: frame.height))
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
            let y = labels.count == 1 ? 0 : wrapLayer.frame.height - CGFloat(index) * (wrapLayer.frame.height / CGFloat(labels.count - 1)) - (config.labelFont.pointSize / 2)
            if config.position == .left {
                textLayer.frame = CGRect(
                    x: config.labelSpacing,
                    y: y,
                    width: frame.width,
                    height: config.labelFont.pointSize + 4
                )
            } else {
                textLayer.frame = CGRect(
                    x: -frame.width - config.labelSpacing,
                    y: y,
                    width: frame.width,
                    height: config.labelFont.pointSize
                )
            }
            
            textLayer.font = config.labelFont
            textLayer.fontSize = config.labelFont.pointSize
            textLayer.foregroundColor = config.labelColor.cgColor
            textLayer.string = text
            textLayer.alignmentMode = config.labelAlignment as String
            textLayer.contentsScale = UIScreen.main.scale
            wrapLayer.addSublayer(textLayer)
        }
        self.addSublayer(wrapLayer)
        labelLayer = wrapLayer
    }
}
