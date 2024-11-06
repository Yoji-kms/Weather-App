//
//  TimelineView.swift
//  Weather App
//
//  Created by Yoji on 25.10.2024.
//

import UIKit

final class TimelineView: UIView {
    private let numberOfPoints: Int
    
    private lazy var timelineAxis: TimelineAxisView = {
        let axis = TimelineAxisView(numberOfPoints: self.numberOfPoints)
        axis.translatesAutoresizingMaskIntoConstraints = false
        return axis
    }()
    
    private lazy var timelineLabels: [UILabel] = {
        var labels = [UILabel]()
        for _ in 0..<self.numberOfPoints {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .left
            labels.append(label)
        }
        return labels
    }()
    
    private lazy var humidityLabels: [UILabel] = {
        var labels = [UILabel]()
        for _ in 0..<self.numberOfPoints {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .left
            labels.append(label)
        }
        return labels
    }()
    
    private lazy var weatherIcons: [UIImageView] = {
        var icons = [UIImageView]()
        for _ in 0..<self.numberOfPoints {
            let icon = UIImageView()
            icon.translatesAutoresizingMaskIntoConstraints = false
            icons.append(icon)
        }
        return icons
    }()
    
    init(numberOfPoints: Int) {
        self.numberOfPoints = numberOfPoints
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }
    
    func setup(with forecast: Forecast) {
        for i in 0..<self.numberOfPoints {
            let weather = forecast.list[i]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm".timeFormat
            let text = dateFormatter.string(from: weather.dt)
            
            self.timelineLabels[i].text = text
            self.humidityLabels[i].text = "\(weather.main.humidity)%"
            self.weatherIcons[i].image = weather.weatherItem.icon
        }
    }
    
    private func setupViews() {
        let axisOffset: CGFloat = 10
        
        self.setupViewsArray(childViews: self.weatherIcons, topAnchor: self.topAnchor, axisOffset: axisOffset)
        
        self.weatherIcons.forEach { icon in
            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 16),
                icon.heightAnchor.constraint(equalToConstant: 16)
            ])
        }
        
        self.setupViewsArray(childViews: self.humidityLabels, topAnchor: self.weatherIcons[0].bottomAnchor, axisOffset: axisOffset)
        
        self.addSubview(self.timelineAxis)
        
        NSLayoutConstraint.activate([
            self.timelineAxis.topAnchor.constraint(equalTo: self.humidityLabels[0].bottomAnchor, constant: 8),
            self.timelineAxis.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: axisOffset),
            self.timelineAxis.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -axisOffset),
            self.timelineAxis.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -axisOffset * 2),
            self.timelineAxis.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        self.setupViewsArray(childViews: self.timelineLabels, topAnchor: self.timelineAxis.bottomAnchor, axisOffset: axisOffset)
    }
}

private extension UIView {
    func setupViewsArray(childViews: [UIView], topAnchor: NSLayoutYAxisAnchor, axisOffset: CGFloat) {
        let step = (self.bounds.width - axisOffset * 2 - 4) / CGFloat(childViews.count - 1)
        
        for i in 0..<childViews.count {
            self.addSubview(childViews[i])
            
            let additionalOffset: CGFloat = i > 0 ? -5 : 0
            let offset = step * CGFloat(i) + additionalOffset + axisOffset
            
            NSLayoutConstraint.activate([
                childViews[i].topAnchor.constraint(equalTo: topAnchor, constant: 8),
                childViews[i].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset)
            ])
        }
    }
}
