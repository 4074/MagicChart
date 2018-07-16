//
//  ViewController.swift
//  MagicChartDemo
//
//  Created by wen on 2018/1/11.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.e
        
        view.backgroundColor = UIColor(red: 52/255, green: 187/255, blue: 171/255, alpha: 1)
        
        lineChart = LineChart()
        lineChart.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 200)
        lineChart.axisConfig.x.lineColor = UIColor.white.withAlphaComponent(0.2)
        lineChart.axisConfig.x.labelColor = .white
        lineChart.axisConfig.x.labelCount = 4
        
        lineChart.axisConfig.y.lineColor = .clear
        lineChart.axisConfig.y.labelColor = .white
        lineChart.axisConfig.y.labelCount = 1
        lineChart.axisConfig.y.labelPosition = .inside
        lineChart.axisConfig.y.labelAlignment = "left"
        lineChart.axisConfig.y.formatter = MagicChartIntFormatter()
        
//        lineChart.animation = false
        lineChart.delegate = self

        view.addSubview(lineChart)
        refreshChart()
        
        let button = UIButton(frame: CGRect(x: 20, y: 320, width: 80, height: 32))
        view.addSubview(button)
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.refreshChart), for: .touchUpInside)
    }
    
    @objc func refreshChart() {
        let dataSource = LineChartDataSource()
        let label = ["06/16", "06/17", "06/18", "06/19", "06/20", "06/21", "06/22"]
        let setOne = lineChart.createDataSet(label, value: [326, 517, 223, 397, 800, 993, 584]) { (set) in
            set.lineDashPattern = []
            set.pointShape = .circle
            set.lineColor = .white
            for i in 0..<label.count - 1 {
                if i < label.count - 2 {
                    set.lineDashPattern.append([])
                } else {
                    set.lineDashPattern.append([4, 4])
                }
            }
        }
        let setTwo = lineChart.createDataSet(label, value: [210, 260, 820, 745, 722, 643, 456]) { (set) in
            set.pointShape = .circle
            set.lineColor = UIColor.white.withAlphaComponent(0.4)
            for i in 0..<label.count - 1 {
                if i < label.count - 2 {
                    set.lineDashPattern.append([])
                } else {
                    set.lineDashPattern.append([4, 4])
                }
            }
        }
        
        dataSource.label = label
        dataSource.sets = [setOne, setTwo]
        lineChart.dataSource = dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: LineChartDelegate {
    func chartView(_ chartView: LineChart, didDraw: Bool) {
        chartView.setSelected(index: chartView.dataSource.label.count - 1)
    }
    
    func chartView(_ chartView: LineChart, didSelect index: Int) {
        print(index)
    }
    
    func chartView(_ chartView: LineChart, styleSelectedLayer layer: CAShapeLayer) {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = layer.bounds
        gradLayer.colors = [UIColor.white.withAlphaComponent(0.1).cgColor, UIColor.white.withAlphaComponent(0.6).cgColor, UIColor.white.withAlphaComponent(0.1).cgColor]
        
        layer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(gradLayer)
    }
}
