//
//  CustomSwitch.swift
//  Weather App
//
//  Created by Yoji on 06.11.2024.
//

import UIKit

final class CustomSwitch: UIControl {
    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var onThumbText = "" {
       didSet {
          self.setupUI()
        }
    }
    public var offThumbText = "" {
         didSet {
            self.setupUI()
         }
    }
    
    public var isOn = true {
        didSet {
            self.setupUI()
        }
    }
    
    private var animationDuration: Double = 0.25
    
    private lazy var thumbView: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .accent
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var onLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        
        return label
    }()
    
    private lazy var offLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        
        return label
    }()
    
    private var onPoint = CGPoint.zero
    private var offPoint = CGPoint.zero
    private var isAnimating = false
    
    private func clear() {
       for view in self.subviews {
          view.removeFromSuperview()
       }
    }
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = true
        self.thumbView.text = !self.isOn ? self.offThumbText : self.onThumbText
        self.onLabel.text = self.offThumbText
        self.offLabel.text = self.onThumbText
        self.onLabel.isHidden = !self.isOn
        self.offLabel.isHidden = self.isOn
        
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        self.addSubview(self.onLabel)
        self.addSubview(self.offLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = 5
            self.backgroundColor = .lightPink

            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(
                width: self.bounds.width/2, height: self.bounds.height
            )
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width, y: yPostition)
            self.offPoint = CGPoint(x: 0, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.onLabel.frame = CGRect(origin: self.offPoint, size: thumbSize)
            self.offLabel.frame = CGRect(origin: self.onPoint, size: thumbSize)
        }
    }
    
    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(
            withDuration: self.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [
                .curveEaseOut,
                .beginFromCurrentState
            ],
            animations: {
                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                self.thumbView.text = self.isOn ? self.onThumbText : self.offThumbText
                
                self.onLabel.isHidden = !self.isOn
                self.offLabel.isHidden = self.isOn
            })  { _ in
                self.isAnimating = false
                self.sendActions(for: .valueChanged)
            }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
      super.beginTracking(touch, with: event)
      self.animate()
      return true
    }
}
