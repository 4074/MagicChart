//
//  LineChartSquarePoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/9/3.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class LineChartSquarePoint: LineChartBasePoint {
    
    override func drawPoint() {
        let radius = configForState.radius.point
        let hole = configForState.radius.hole
        let path = UIBezierPath()
        let pathCenter = CGPoint(x: center.x, y: center.y)
        
        let num = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
        let lineWidth = num - hole
        let step = hole + lineWidth / 2
        let points = [
            CGPoint(x: pathCenter.x + step, y: pathCenter.y - step),
            CGPoint(x: pathCenter.x + step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y + step),
            CGPoint(x: pathCenter.x - step, y: pathCenter.y - step)
        ]
        
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
        pointLayer.lineWidth = lineWidth
        pointLayer.path = path.cgPath
        pointLayer.contentsScale = UIScreen.main.scale
        
        pointLayer.strokeColor = configForState.colors.point.cgColor
        pointLayer.fillColor = UIColor.clear.cgColor
    }
    
    override func drawShadow() {
        let radius = configForState.radius.point
        let r = radius + configForState.radius.shadow
        
        shadowLayer.fillColor = configForState.colors.shadow.cgColor
        
        let path = UIBezierPath()
        let sr: CGFloat = CGFloat(sqrt((Double(r) * Double(r)) * Double.pi) / 2) * 2
        let orign = CGPoint(x: center.x - sr/2, y: center.y - sr/2)
        path.move(to: orign)
        path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y))
        path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y + sr))
        path.addLine(to: CGPoint(x: orign.x, y: orign.y + sr))
        path.close()
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
    
    override func drawHole() {
        let radius = configForState.radius.hole
        holeLayer.fillColor = configForState.colors.hole.cgColor
        
        let path = UIBezierPath()
        let sr: CGFloat = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2) * 2
        let orign = CGPoint(x: center.x - sr/2, y: center.y - sr/2)
        path.move(to: orign)
        path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y))
        path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y + sr))
        path.addLine(to: CGPoint(x: orign.x, y: orign.y + sr))
        path.close()
        
        holeLayer.path = path.cgPath
    }
}
