//
//  TimelineAxisView.swift
//  Weather App
//
//  Created by Yoji on 25.10.2024.
//

import UIKit

final class TimelineAxisView: UIView {
    private let numberOfPoints: Int
    private let pointWidth: CGFloat = 4
    private let pointHeight: CGFloat = 8
    
    private lazy var pointViews: [UIView] = {
        var views = [UIView]()
        for _ in 0..<self.numberOfPoints {
            let view = UIView()
            view.backgroundColor = .accent
            view.translatesAutoresizingMaskIntoConstraints = false
            views.append(view)
        }
        return views
    }()
    
    private lazy var axisView: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(numberOfPoints: Int) {
        self.numberOfPoints = numberOfPoints
        super.init(frame: .zero)
        self.backgroundColor = .clear
//        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }
    
    private func setupViews() {
        let step: CGFloat = (self.bounds.width - self.pointWidth) / CGFloat(self.numberOfPoints - 1)
        
        for i in 0..<numberOfPoints {
            self.addSubview(self.pointViews[i])
            
            let offset = step * CGFloat(i)
            
            NSLayoutConstraint.activate([
                self.pointViews[i].topAnchor.constraint(equalTo: self.topAnchor),
                self.pointViews[i].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
                self.pointViews[i].widthAnchor.constraint(equalToConstant: self.pointWidth),
                self.pointViews[i].heightAnchor.constraint(equalToConstant: self.pointHeight)
            ])
        }
        
        self.addSubview(self.axisView)
        
        NSLayoutConstraint.activate([
            self.axisView.centerYAnchor.constraint(equalTo: self.pointViews[0].centerYAnchor),
            self.axisView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.axisView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.axisView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
