//
//  ChartUtils.swift
//  MagicChartDemo
//
//  Created by wen on 2018/6/29.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class ChartUtils {
    static func getNestNumber(source: Double, rate: Double = 0.8) -> Double {
        let weight = source < 1 ? 0.001 : pow(10, Double((String(Int(source)).count - 2)))
        var result = 2 * weight
        while result * rate < source {
            result += 2 * weight
        }
        return result
    }
    
    static func computeSelectedIndex(point: CGPoint, frame: CGRect, count: Int) -> Int {
        var index = count - 1
        let step = frame.width / CGFloat(count - 1)
        for i in 0..<count {
            if point.x - frame.minX <= (CGFloat(i) + 0.5) * step {
                index = i
                break
            }
        }
        
        return index
    }
    
    static func createCircleShape(center: CGPoint, radius: CGFloat, color: UIColor, hole: CGFloat = 0) -> CAShapeLayer {
        let circle = CAShapeLayer()
        let lineWidth = radius - hole
        circle.frame = CGRect(origin: CGPoint(x: center.x - radius, y: center.y - radius), size: CGSize(width: radius, height: radius))
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: lineWidth/2 + hole, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        circle.path = path.cgPath
        circle.strokeColor = color.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = radius - hole
        return circle
    }
    
    static func createSquareShape(center: CGPoint, radius: CGFloat, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        let pathCenter = CGPoint(x: radius, y: radius)
        
        let num = CGFloat(sqrt((Double(radius) * Double(radius)) * Double.pi) / 2)
        let x_start = pathCenter.x - num
        let x_end = pathCenter.x + num
        
        layer.frame = CGRect(origin: CGPoint(x: center.x - radius, y: center.y - radius), size: CGSize(width: radius, height: radius))
        path.move(to: pathCenter)
        
        path.move(to: CGPoint(x: x_start, y: pathCenter.y))
        path.addLine(to: CGPoint(x: x_end, y: pathCenter.y))
        layer.lineWidth = num * 2
        layer.path = path.cgPath
        layer.contentsScale = UIScreen.main.scale
        
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }
    
    static func selectNumbers(min: Double, max: Double, count: Int) -> [Double] {
        var values = [Double]()
        
        if count <= 1 {
            values = [max]
        } else {
            let step = max / Double(count - 1)
            var num = min
            for _ in 0..<count {
                let n = ceil(num)
                if !values.contains(n) {
                    values.append(n)
                }
                num += step
            }
        }
        
        return values
    }
    
    static func selectStrings(source: [String], count: Int, force: Bool = false) -> [String] {
        var result = [String]()
        var indexList = [Int]()
        
        if source.isEmpty || source.count <= count {
            return source
        }
        
        if count == 0 {
            
        } else if count == 1 {
            let index = Int(floor(Double(source.count - 1) / 2))
            indexList.append(index)
        } else {
            if (source.count - 1) % (count - 1) == 0 {
                let step = (source.count - 1) / (count - 1)
                for i in 0..<source.count {
                    if i % step == 0 {
                        indexList.append(i)
                    }
                }
            } else {
                if force || (Double(source.count) / Double(count)) > 3 {
                    indexList.append(0)
                    
                    let step = Double(source.count + 1) / Double(count - 1)
                    var i: Double = 1
                    while (indexList.count < count - 1) {
                        let index = Int(floor(i * step))
                        indexList.append(index)
                        i += 1
                    }
                    
                    indexList.append(source.count - 1)
                } else {
                    return selectStrings(source: source, count: count - 1, force: true)
                }
            }
        }
        
        for i in 0..<source.count {
            if indexList.contains(i) {
                result.append(source[i])
            } else {
                result.append("")
            }
        }
        
        return result
    }
    
    static func getNumberRange(source: [[Double]]) -> (minimum: Double, maximum: Double) {
        var minimum: Double = Double.infinity
        var maximum: Double = -Double.infinity
        
        for set in source {
            if let m = set.min() {
                minimum = min(m, minimum)
            }
            if let m = set.max() {
                maximum = max(m, maximum)
            }
        }
        
        return (minimum, maximum)
    }
    
    static func getMaxStringWidth(strings: [String], font: UIFont) -> CGFloat {
        var width: CGFloat = 0
        for str in strings {
            width = max(width, getStringWidth(string: str, font: font))
        }
        return width
    }
    
    static func getStringWidth(string: String, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: 999, height: 999)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}


