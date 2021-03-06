//
//  PointAnimationor.swift
//  MagicChartDemo
//
//  Created by wen on 2018/5/10.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

public class PointAnimator {
    
    var link: CADisplayLink?
    var sourceLayer: CAShapeLayer?
    var points: [CGPoint?] = []
    var layers: [LineChartPoint] = []
    var duration: TimeInterval = 0
    var nextIndex: Int = 0
    var completion = false
    
    var completionBlock: (() -> Void)?
    
    init(source: CAShapeLayer, duration: TimeInterval, points: [CGPoint?], layers: [LineChartPoint]) {
        self.sourceLayer = source
        self.duration = duration
        self.points = points
        self.layers = layers
        
        for layer in layers {
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Find layers need excute display animation
            let configForState = layer.active ? layer.config.active : layer.config.normal
            if configForState.radius.point > 0 {
                layer.opacity = 0
            }
        }
    }
    
    func start() {
        link = CADisplayLink.init(target: self, selector: #selector(self.handleDisplayLink))
        link?.add(to: .current, forMode: .common)
    }
    
    @objc
    func stop(completion: Bool = true) {
        if !self.completion {
            self.completion = completion
            link?.invalidate()
            
            if let d = completionBlock {
                d()
            }
        }
    }
    
    func setCompletionBlock(_ block: (() -> Void)?) {
        completionBlock = block
    }
    
    @objc
    func handleDisplayLink() {
        if let width = sourceLayer?.presentation()?.path?.boundingBoxOfPath.width {
            displayLayerIfNeed(width: width)
        }
    }
    
    func displayLayerIfNeed(width: CGFloat) {
        for index in nextIndex..<points.count {
            if let point = points[index] {
                if width >= point.x - 24 {
                    if index < layers.count {
                        if (layers[index].active ? layers[index].config.active : layers[index].config.normal).radius.point > 0 {
                            displayLayer(layer: layers[index])
                        }
                    }
                    nextIndex = index + 1
                    
                    if nextIndex >= points.count {
                        stop()
                    }
                    
                    break
                }
            }
        }
    }
    
    func displayLayer(layer: CAShapeLayer) {
        if layer.opacity == 1 { return }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        
//        let transformAnimation = CABasicAnimation(keyPath: "transform")
//        transformAnimation.fromValue = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 2, y: 2))
//        transformAnimation.toValue = CATransform3DIdentity
        
        let group = CAAnimationGroup()
        
        group.animations = [opacityAnimation]
        
        group.duration = 0.4
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        
        layer.add(group, forKey: "display")
    }
}



