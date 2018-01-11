//
//  ViewController.swift
//  MagicChartDemo
//
//  Created by wen on 2018/1/11.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.e
        
        let lineChart = LineChart()
        view.addSubview(lineChart)
        
        let set = LineChartDataSet()
        set.value = [3, 5, 7, 2, 10, 9]
        lineChart.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 200)
        lineChart.dataSet = [set]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

