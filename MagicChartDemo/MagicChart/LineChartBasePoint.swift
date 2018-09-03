//
//  LineChartBasePoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/9/3.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class LineChartBasePoint: LineChartPoint {

    public var center: CGPoint!
    public var configForState: (radius: LineChartPointRadius, colors: LineChartPointColor)!
    
    public var shadowLayer: CAShapeLayer!
    public var pointLayer: CAShapeLayer!
    public var holeLayer: CAShapeLayer!
    
    override init(layer: Any) {
        super.init(layer: layer)
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

    func drawPoint() {}
    func drawHole() {}
    func drawShadow() {}
}
