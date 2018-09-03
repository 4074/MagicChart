//
//  LineChartDiamondPoint.swift
//  MagicChartDemo
//
//  Created by wen on 2018/9/3.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class LineChartDiamondPoint: LineChartSquarePoint {

    override func drawPoint() {
        super.drawPoint()
        pointLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
    }
    
    override func drawHole() {
        super.drawHole()
        holeLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
    }
    
    override func drawShadow() {
        super.drawShadow()
        shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi/4))
    }
    
}
