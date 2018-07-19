//
//  LineChartCirclePoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/13.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class LineChartCirclePoint: LineChartPoint {
    var radiusOrigin: CGFloat!
    var center: CGPoint!
    
    var shadowLayer: CAShapeLayer!
    var pointLayer: CAShapeLayer!
    var holeLayer: CAShapeLayer!
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public init(center: CGPoint, config: LineChartPointConfig) {
        super.init()
        self.config = config
        self.configForState = config.normal
        self.center = CGPoint(x: 50, y: 50)
        
        self.frame = CGRect(origin: CGPoint(x: center.x - 50, y: center.y - 50), size: CGSize(width: 100, height: 100))
        
        pointLayer = CAShapeLayer()
        pointLayer.frame = self.bounds
        self.addSublayer(pointLayer)
        drawPoint()
        
        holeLayer = CAShapeLayer()
        holeLayer.frame = self.bounds
        self.addSublayer(holeLayer)
        drawHole()
        
        shadowLayer = CAShapeLayer()
        shadowLayer.frame = self.bounds
        self.insertSublayer(shadowLayer, at: 0)
        drawShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawPoint() {
        switch config.normal.shape {
        case .circle:
            drawCircleShape()
        case .square:
            drawSquareShape()
            // TODO: rotation
//            self.anchorPoint = CGPoint(x: radius, y: radius)
//            self.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
        default:
            return
        }
    }
    
    override public func toggleActive() {
        if !active {
            configForState = config.normal
        } else {
            configForState = config.active
        }
        
        drawPoint()
        drawHole()
        drawShadow()
    }
    
    func drawShadow() {
        let radius = configForState.radius
        let r = radius + configForState.shadow
        
        shadowLayer.fillColor = configForState.colors.shadow.cgColor
        
        let path = UIBezierPath()
        if configForState.shape == .circle {
            path.addArc(withCenter: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else if configForState.shape == .square {
            let sr = CGFloat(sqrt((Double(r) * Double(r)) * Double.pi) / 2)
            path.move(to: CGPoint(x: radius - sr, y: radius - sr))
            path.addLine(to: CGPoint(x: radius + sr, y: radius - sr))
            path.addLine(to: CGPoint(x: radius + sr, y: radius + sr))
            path.addLine(to: CGPoint(x: radius - sr, y: radius + sr))
            path.close()
        }
        shadowLayer.path = path.cgPath

        let m = CAShapeLayer()
        let mpath = CGMutablePath()
        mpath.addRect(shadowLayer.bounds)

        if let p = holeLayer.path {
            mpath.addPath(p)
            m.fillRule = kCAFillRuleEvenOdd
            m.path = mpath
            shadowLayer.mask = m
        }
    }
    
    func drawHole() {
        let radius = configForState.hole

        holeLayer.fillColor = configForState.colors.hole.cgColor
        
        let path = UIBezierPath()
        if configForState.shape == .circle {
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else if configForState.shape == .square {
            let sr = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
            path.move(to: CGPoint(x: radius - sr, y: radius - sr))
            path.addLine(to: CGPoint(x: radius + sr, y: radius - sr))
            path.addLine(to: CGPoint(x: radius + sr, y: radius + sr))
            path.addLine(to: CGPoint(x: radius - sr, y: radius + sr))
            path.close()
        }
        holeLayer.path = path.cgPath
    }
    
    func drawCircleShape() {
        let radius = configForState.radius
        let hole = configForState.hole
        
        let lineWidth = radius - hole
        let path = UIBezierPath(arcCenter: center, radius: lineWidth/2 + hole, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        pointLayer.path = path.cgPath
        pointLayer.strokeColor = configForState.colors.point.cgColor
        pointLayer.fillColor = UIColor.clear.cgColor
        pointLayer.lineWidth = radius - hole
    }
    
    func drawSquareShape() {
        let radius = configForState.radius
        let hole = configForState.hole
        let path = UIBezierPath()
        let pathCenter = CGPoint(x: radius, y: radius)
        
        let num = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
        let lineWidth = num - hole
        let step = hole + lineWidth / 2
        let points = [
            CGPoint(x: pathCenter.x + step, y: pathCenter.y - step),
            CGPoint(x: pathCenter.x + step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y - step)
        ]
        
        self.frame = CGRect(origin: CGPoint(x: center.x - radius, y: center.y - radius), size: CGSize(width: radius, height: radius))
        
        path.move(to: points.last!)
        for (i, p) in points.enumerated() {
            if i == 0 {
                path.addLine(to: CGPoint(x: p.x + lineWidth/2, y: p.y))
            } else if i == 1 {
                path.addLine(to: CGPoint(x: p.x, y: p.y + lineWidth/2))
            } else if i == 2 {
                path.addLine(to: CGPoint(x: p.x - lineWidth/2, y: p.y))
            } else if i == 3 {
                path.addLine(to: CGPoint(x: p.x, y: p.y - lineWidth/2))
            }
            
            path.move(to: p)
        }
        self.lineWidth = lineWidth
        self.path = path.cgPath
        self.contentsScale = UIScreen.main.scale
        
        self.strokeColor = configForState.colors.point.cgColor
        self.fillColor = UIColor.clear.cgColor
    }
}
