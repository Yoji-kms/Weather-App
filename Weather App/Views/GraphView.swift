//
//  GraphView.swift
//  Weather App
//
//  Created by Yoji on 23.10.2024.
//

import UIKit
import DGCharts

final class GraphView: UIView  {
    private let numberOfPoints = 8
    
    private var chartData = [ChartDataEntry]()
    
    private lazy var timeline: TimelineView = {
        let timelineView = TimelineView(numberOfPoints: numberOfPoints)
        timelineView.translatesAutoresizingMaskIntoConstraints = false
        return timelineView
    }()
    
    private lazy var chart: LineChartView = {
        let chartView = LineChartView()

        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.drawLabelsEnabled = false
        yAxis.enabled = true
        yAxis.drawZeroLineEnabled = true
        yAxis.drawGridLinesEnabled = false
        yAxis.zeroLineColor = .accent
        yAxis.zeroLineWidth = 1
        yAxis.zeroLineDashLengths = [8]
        
        yAxis.drawAxisLineEnabled = true
        yAxis.axisLineColor = .accent
        yAxis.axisLineWidth = 1
        yAxis.axisLineDashLengths = [8]
        
        chartView.xAxis.enabled = false
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = Double(numberOfPoints - 1)
        
        chartView.backgroundColor = .clear
        chartView.gridBackgroundColor = .clear
        chartView.drawGridBackgroundEnabled = true
        chartView.extraTopOffset = 24
        
        chartView.legend.enabled = false
        chartView.isUserInteractionEnabled = false
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
//    MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightBlue
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with forecast: Forecast) {
        self.timeline.setup(with: forecast)
        
        let temperatures = forecast.list.map { $0.main.temp.temperature }
        guard let maxTemperature = temperatures.max() else { return }
        guard let minTemperature = temperatures.min() else { return }
        
        for x in 0..<self.numberOfPoints {
            let weather = forecast.list[x]
            let temperature = Double(weather.main.temp.temperature)
            let chartDataEntry = ChartDataEntry(x: Double(x), y: temperature)
            
            self.chartData.append(chartDataEntry)
        }
        
        self.chart.data = self.chartData.data
        
        if maxTemperature < 0 {
            self.chart.leftAxis.axisMaximum = 0
        } else if minTemperature > 0 {
            self.chart.leftAxis.axisMaximum = Double(maxTemperature)
            self.chart.leftAxis.axisMinimum = 0
        } 
    }
    
    private func setupViews() {
        self.addSubview(self.chart)
        self.addSubview(self.timeline)
        
        NSLayoutConstraint.activate([
            self.chart.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.chart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            self.chart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.chart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            
            self.timeline.topAnchor.constraint(equalTo: self.chart.bottomAnchor),
            self.timeline.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            self.timeline.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.timeline.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}

private final class ChartValueFormatter: NSObject, ValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
        else {
            return ""
        }
        return numberFormatter.string(for: value)!
    }
}

private extension [ChartDataEntry] {
    var data: LineChartData {
        let set = LineChartDataSet(entries: self)
        set.mode = .horizontalBezier
        set.drawFilledEnabled = true
        set.drawCircleHoleEnabled = false
        set.circleRadius = 3
        set.circleColors = [.white]
        
        set.setColor(.accent)
        set.lineWidth = 1
        set.fillAlpha = 0.5
        set.highlightColor = .clear
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = "º"
        formatter.negativeSuffix = "º"
        set.valueFormatter = ChartValueFormatter(numberFormatter: formatter)
        set.valueFont = .systemFont(ofSize: 14)
        
        let gradientColors = [UIColor.white.cgColor, UIColor.accent.cgColor]
        guard let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil) else {
            return LineChartData(dataSet: set)
        }
        set.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        let data = LineChartData(dataSet: set)
        return data
    }
}
