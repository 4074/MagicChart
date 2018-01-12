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
        
        lineChart = LineChart()
        lineChart.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 200)
        view.addSubview(lineChart)
        refreshChart()
        
        let button = UIButton(frame: CGRect(x: 20, y: 300, width: 80, height: 32))
        view.addSubview(button)
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(self.refreshChart), for: .touchUpInside)
    }
    
    @objc func refreshChart() {
        let dataSource = LineChartDataSource()
        let label = ["1", "2", "3", "4", "5", "6"]
        let sets = lineChart.createDataSet(label, groups: [[3, 5, 2, 3, 1, 9], [9, 10, 8, 7, 12, 12]]) { (set, index) in
            if index == 0 {
                set.pointShape = .circle
            } else {
                set.pointShape = .square
            }
        }
        
        dataSource.label = label
        dataSource.sets = sets
        lineChart.dataSource = dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

