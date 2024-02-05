//
//  CurveView.swift
//  Weather App
//
//  Created by Yoji on 02.02.2024.
//

import UIKit

class CurveView: UIView {
    private lazy var curve: UIBezierPath = {
        let start = CGPoint(x: self.bounds.minX + 40, y: self.bounds.maxY - 72)
        let end = CGPoint(x: self.bounds.maxX - 40, y: self.bounds.maxY - 72)
        let curveStart = CGPoint(x: self.bounds.minX + 40, y: self.bounds.minY - 32)
        let curveEnd = CGPoint(x: self.bounds.maxX - 40, y: self.bounds.minY - 32)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: curveStart, controlPoint2: curveEnd)
        return path
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(resource: .darkYellow).cgColor
        shapeLayer.fillColor = UIColor(resource: .accent).cgColor
        shapeLayer.lineWidth = 3
        return shapeLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayer()
    }

    func setupLayer() {
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        shapeLayer.path = curve.cgPath
    }
}
