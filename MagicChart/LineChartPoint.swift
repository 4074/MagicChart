//
//  LineChartPoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/13.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class LineChartPoint: CAShapeLayer {
    var shape: MagicChartPointShape!
    var active: Bool = false {
        didSet {
            if oldValue != active {
                toggleActive()
            }
        }
    }
    var color: UIColor!
    var radius: CGFloat!
    var radiusOrigin: CGFloat!
    var hole: CGFloat = 0
    var center: CGPoint!
    
    var shadow: CAShapeLayer!
    var point: CAShapeLayer!
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(center: CGPoint, shape: MagicChartPointShape, color: UIColor, radius: CGFloat, hole: CGFloat = 0) {
        super.init()
        self.shape = shape
        self.color = color
        self.radius = radius
        self.radiusOrigin = radius
        self.hole = radius - 2
        self.center = center
        
        shadow = CAShapeLayer()
        shadow.isHidden = true
        self.addSublayer(shadow)
        drawShadow()
        
        point = CAShapeLayer()
        self.addSublayer(point)
        drawPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawPoint() {
        switch shape {
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
    
    func toggleActive() {
        if !active {
            radius = radiusOrigin
            hole = 0
            shadow.isHidden = true
        } else {
            radius = radiusOrigin + 1
            hole = radius - 2
            shadow.isHidden = false
        }
        
        drawShadow()
//        drawPoint()
    }
    
    func drawShadow() {
        let r = radius + 3
        shadow.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: r, height: r))
        shadow.fillColor = color.withAlphaComponent(0.3).cgColor
        
        let path = UIBezierPath()
        if shape == .circle {
            path.addArc(withCenter: CGPoint(x: radiusOrigin, y: radiusOrigin), radius: r, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else if shape == .square {
            let sr = CGFloat(sqrt((Double(r) * Double(r)) * Double.pi) / 2)
            path.move(to: CGPoint(x: radiusOrigin - sr, y: radiusOrigin - sr))
            path.addLine(to: CGPoint(x: radiusOrigin + sr, y: radiusOrigin - sr))
            path.addLine(to: CGPoint(x: radiusOrigin + sr, y: radiusOrigin + sr))
            path.addLine(to: CGPoint(x: radiusOrigin - sr, y: radiusOrigin + sr))
            path.close()
        }
        shadow.path = path.cgPath
    }
    
    func drawCircleShape() {
        self.frame = CGRect(origin: CGPoint(x: center.x - radiusOrigin, y: center.y - radiusOrigin), size: CGSize(width: radius, height: radius))
        
        point.frame = self.bounds
        let lineWidth = radius - hole
        let path = UIBezierPath(arcCenter: CGPoint(x: radiusOrigin, y: radiusOrigin), radius: lineWidth/2 + hole, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        point.path = path.cgPath
        point.strokeColor = color.cgColor
        point.fillColor = UIColor.clear.cgColor
        point.lineWidth = radius - hole
    }
    
    func drawSquareShape() {
        let path = UIBezierPath()
        let pathCenter = CGPoint(x: radiusOrigin, y: radiusOrigin)
        
        let num = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
        let lineWidth = num - hole
        let step = hole + lineWidth / 2
        let points = [
            CGPoint(x: pathCenter.x + step, y: pathCenter.y - step),
            CGPoint(x: pathCenter.x + step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y - step)
        ]
        
        self.frame = CGRect(origin: CGPoint(x: center.x - radiusOrigin, y: center.y - radiusOrigin), size: CGSize(width: radius, height: radius))
        
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
        
        self.strokeColor = color.cgColor
        self.fillColor = UIColor.clear.cgColor
    }
}
