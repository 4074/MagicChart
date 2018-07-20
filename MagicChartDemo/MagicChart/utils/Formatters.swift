//
//  Formatters.swift
//  MagicChartDemo
//
//  Created by wen on 2018/7/9.
//  Copyright © 2018年 wenfeng. All rights reserved.
//

import Foundation

public class MagicChartPercentageFormatter: NumberFormatter {
    override public func string(from number: NSNumber) -> String? {
        let value = round(Double(truncating: number) * 100)
        
        if value == 0 {
            return "0"
        }
        return String(Int(value)) + "%"
    }
}

public class MagicChartIntFormatter: NumberFormatter {
    override public func string(from number: NSNumber) -> String? {
        let num = NSNumber(value: Int64(round(Double(truncating: number))))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: num) ?? ""
    }
}
