//
//  LineChartCirclePoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/13.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class LineChartCirclePoint: LineChartBasePoint {
    override func drawPoint() {
        let radius = configForState.radius.point
        let hole = configForState.radius.hole
        
        let lineWidth = radius - hole
        let path = UIBezierPath(arcCenter: center, radius: lineWidth/2 + hole, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        pointLayer.path = path.cgPath
        pointLayer.strokeColor = configForState.colors.point.cgColor
        pointLayer.fillColor = UIColor.clear.cgColor
        pointLayer.lineWidth = radius - hole
    }
    
    override func drawShadow() {
        let radius = configForState.radius.point
        let r = radius + configForState.radius.shadow
        
        shadowLayer.fillColor = configForState.colors.shadow.cgColor
        
        let path = UIBezierPath()
        switch config.shape {
        case .circle:
            path.addArc(withCenter: center, radius: r, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        case .square, .diamond:
            let sr: CGFloat = CGFloat(sqrt((Double(r) * Double(r)) * Double.pi) / 2) * 2
            let orign = CGPoint(x: center.x - sr/2, y: center.y - sr/2)
            path.move(to: orign)
            path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y))
            path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y + sr))
            path.addLine(to: CGPoint(x: orign.x, y: orign.y + sr))
            path.close()
            if config.shape == .diamond {
                shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
            }
        default:
            break
        }
        shadowLayer.path = path.cgPath
        
        let m = CAShapeLayer()
        let mpath = CGMutablePath()
        mpath.addRect(shadowLayer.bounds)

        if let p = holeLayer.path {
            mpath.addPath(p)
            m.fillRule = CAShapeLayerFillRule.evenOdd
            m.path = mpath
            shadowLayer.mask = m
        }
    }
    
    override func drawHole() {
        let radius = configForState.radius.hole
        holeLayer.fillColor = configForState.colors.hole.cgColor
        
        let path = UIBezierPath()
        switch config.shape {
        case .circle:
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        case .square, .diamond:
            let sr: CGFloat = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2) * 2
            let orign = CGPoint(x: center.x - sr/2, y: center.y - sr/2)
            path.move(to: orign)
            path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y))
            path.addLine(to: CGPoint(x: orign.x + sr, y: orign.y + sr))
            path.addLine(to: CGPoint(x: orign.x, y: orign.y + sr))
            path.close()
            if config.shape == .diamond {
                holeLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
            }
        default:
            break
        }
        
        holeLayer.path = path.cgPath
    }
}
