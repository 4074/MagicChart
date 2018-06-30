//
//  BaseChart.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class AxisChart: UIView {

    var colors: [UIColor] = [.green, .blue, .orange, .red]
    
    var rangeType: (minimum: MagicChartAxisRangeType, maximum: MagicChartAxisRangeType) = (.zero, .auto)
    var range: (minimum: Double, maximum: Double)?

    var chartLayer: CALayer?
    var dataLayer: CALayer?
    
    var inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    var axisSize: (x: CGSize, y: CGSize) = (.zero, .zero)
    
    var axisLayer: (x: ChartXAxis?, y: ChartYAxis?) = (nil, nil)
    var axisLineWidth: (x: CGFloat, y: CGFloat) = (0.8, 0.8)
    var axisLineColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    
    var axisLabelCount: (x: Int, y: Int) = (4, 4)
    var axisLabelFont: (x: UIFont, y: UIFont) = (UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12))
    var axisLabelColor: (x: UIColor, y: UIColor) = (.lightGray, .lightGray)
    var axisLabelSpacing: (x: CGFloat, y: CGFloat) = (4, 8)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDidUpdate(location: t.location(in: self))
            break
        }
    }
    
    func touchDidUpdate(location: CGPoint) {
        
    }
}
