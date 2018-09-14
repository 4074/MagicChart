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
        lineChart.axis.x.lineColor = UIColor.white.withAlphaComponent(0.2)
        lineChart.axis.x.labelColor = .white
        lineChart.axis.x.labelCount = 4
        
        lineChart.axis.y.left.lineColor = .clear
        lineChart.axis.y.left.labelColor = .white
        lineChart.axis.y.left.labelCount = 1
        lineChart.axis.y.left.labelPosition = .inside
        lineChart.axis.y.left.labelAlignment = "left"
        lineChart.axis.y.left.labelSpacing = 0
        lineChart.axis.y.left.formatter = MagicChartIntFormatter()
        
        lineChart.axis.y.right.lineColor = .clear
        lineChart.axis.y.right.labelColor = .white
        lineChart.axis.y.right.labelCount = 1
        lineChart.axis.y.right.labelPosition = .inside
        lineChart.axis.y.right.labelAlignment = "right"
        lineChart.axis.y.right.labelSpacing = 0
        lineChart.axis.y.right.formatter = MagicChartIntFormatter()
        
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
        let setOne = lineChart.createDataSet(label, value: [42, 81, nil, 62, 80, 99, 120]) { (set) in
            set.point = LineChartPointConfig(
                shape: .circle,
                normal: (LineChartPointRadius(point: 4, hole: 0, shadow: 0), LineChartPointColor(point: UIColor.white, hole: UIColor.clear, shadow: UIColor.white.withAlphaComponent(0.4))),
                active: (LineChartPointRadius(point: 4, hole: 0, shadow: 4), LineChartPointColor(point: UIColor.white, hole: UIColor.clear, shadow: UIColor.white.withAlphaComponent(0.4)))
            )
            set.lineColor = .white
            set.lineStyle = .line
            let count = 6
            for i in 0..<count {
                if i < count - 1 {
                    set.lineDashPattern.append([])
                } else {
                    set.lineDashPattern.append([4, 4])
                }
            }
        }
        let setTwo = lineChart.createDataSet(label, value: [210, 260, 820, 745, 722, 643, 601]) { (set) in
            set.point = LineChartPointConfig(
                shape: .diamond,
                normal: (LineChartPointRadius(point: 4, hole: 0, shadow: 0), LineChartPointColor(point: UIColor.white, hole: UIColor.clear, shadow: UIColor.white.withAlphaComponent(0.4))),
                active: (LineChartPointRadius(point: 4, hole: 0, shadow: 4), LineChartPointColor(point: UIColor.white, hole: UIColor.clear, shadow: UIColor.white.withAlphaComponent(0.4)))
            )
            set.lineColor = UIColor.white.withAlphaComponent(0.4)
            set.yAxisPosition = .right
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
        chartView.setSelected(index: chartView.dataSource.sets[1].value.values.count - 1)
    }
    
    func chartView(_ chartView: LineChart, didSelect index: Int) {
        print("Point \(index) selected")
    }
    
    func chartView(_ chartView: LineChart, styleSelectedLayer layer: CAShapeLayer) {
        let gradLayer = CAGradientLayer()
        gradLayer.frame = layer.bounds
        gradLayer.colors = [UIColor.white.withAlphaComponent(0.1).cgColor, UIColor.white.withAlphaComponent(0.6).cgColor, UIColor.white.withAlphaComponent(0.1).cgColor]
        
        layer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(gradLayer)
    }
}
