# MagicChart (马鸡茶)

![Image of Line Chart](./screenshots/line.gif)

## Why one more chart library? (为什么又一个图形库)
Before, I draw chart with [danielgindi/Charts](https://github.com/danielgindi/Charts) that is a amazing library. 

One day, I received some amazing tasks, such as add animation, render series without one point, 
draw a line with dash pattern, cool selected style, etc... So, I need a library to implement that. 

This is why we play! emmm, Why we write.

The targets of this chart library:
- Support for high degree of customization
- Amazing animation
- Simple to use
- Elegant implement

Now, I just wrote line chart. Welcome any issues/ideas/prs.

之前，我都是用 [danielgindi/Charts](https://github.com/danielgindi/Charts)(一个很优秀的库) 绘制图形，生活还算愉快。后来，牛逼的需求越来越多，例如流畅的动画、缺失的数据点、实线虚线结合、酷炫的选中样式等等。

这时候，有一个想法就自然而然出现了——是时候需要一个新的 iPhone 了，噢噢，新的图形库。

最后，Duang！！这个库就被写出来了。

列几个这个图形库期望达到的目标：
- 支持高度的定制化
- 实用且酷炫的动画
- 使用尽量简单
- 实现优雅

我现在只写了线形图。强烈欢迎各类贡献，包括但不限于 issues/ideas/prs

## Install

With cocoapods
```ruby
# for swift 4
pod 'MagicChart' ~> '0.2'

# for swift 3
pod 'MagicChart' ~> '0.1'
```

## Usage

You can read and run the demo.

```swift
    let lineChart = LineChart()
    lineChart.frame = CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 200)

    let dataSource = LineChartDataSource()
    let label = ["06/16", "06/17", "06/18", "06/19", "06/20", "06/21", "06/22"]
    let set = lineChart.createDataSet(label, value: [42, 81, nil, 62, 80, 99, 120]) { (set) in}
    dataSource.label = label
    dataSource.sets = [set]
    lineChart.dataSource = dataSource
```

# TODOs

- Bar Chart
- LineBar Chart
- Area Chart
- LineArea Chart
- Other Chart