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
    var gridLayer: CAShapeLayer?
    var gridPositions: [CGFloat] = []
    
    func render() {
        drawGrid()
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
    
    func drawGrid() {
        if let o = gridLayer {
            o.removeFromSuperlayer()
            gridLayer = nil
        }
    }
    
    func createLineLayer(origin: CGPoint, end: CGPoint, width: CGFloat? = nil, color: UIColor? = nil) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: origin)
        path.addLine(to: end)
        
        layer.path = path.cgPath
        layer.strokeColor = (color ?? config.lineColor).cgColor
        layer.lineWidth = width ?? config.lineWidth
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
    
    override func drawGrid() {
        super.drawGrid()
        
        if !config.gridVisible { return }
        
        gridLayer = CAShapeLayer()
        gridLayer?.frame = self.bounds
        for y in gridPositions {
            let l = createLineLayer(
                origin: CGPoint(x: 0, y: 0),
                end: CGPoint(x: frame.width, y: 0),
                width: config.gridWidth,
                color: config.gridColor
            )
            l.frame = CGRect(x: 0, y: -y, width: frame.width, height: config.gridWidth)
            gridLayer?.addSublayer(l)
        }
        self.addSublayer(gridLayer!)
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
    
    func getPositions() -> [CGFloat] {
        var positions = [CGFloat]()
        for (index, _) in labels.enumerated() {
            let y = labels.count == 1 ? 0 : frame.height - CGFloat(index) * (frame.height / CGFloat(labels.count - 1))
            positions.append(y)
        }
        return positions
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
        
        let labels = config.reverse ? self.labels.reversed() : self.labels
        let positions = getPositions()
        
        for (index, text) in labels.enumerated() {
            if text.isEmpty {
                continue
            }
            let textLayer = CATextLayer()
            let y = positions[index] - (config.labelFont.pointSize / 2)
            if config.position == .left {
                let x = config.labelPosition == .outside ? 0 : config.labelSpacing
                textLayer.frame = CGRect(
                    x: x,
                    y: y,
                    width: frame.width,
                    height: config.labelFont.pointSize + 4
                )
            } else {
                textLayer.frame = CGRect(
                    x: -frame.width - config.labelSpacing,
                    y: y,
                    width: frame.width,
                    height: config.labelFont.pointSize + 4
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
