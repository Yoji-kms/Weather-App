//
//  SettingsView.swift
//  Weather App
//
//  Created by Yoji on 06.11.2024.
//

import UIKit

final class SettingsView: UIView {
    private let secondaryTextColor: UIColor = .systemGray
    
    private lazy var settinsLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: Strings.settings.rawValue)
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: Strings.temperature.rawValue)
        label.textColor = self.secondaryTextColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: Strings.windSpeed.rawValue)
        label.textColor = self.secondaryTextColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var timeFormatLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: Strings.timeFormat.rawValue)
        label.textColor = self.secondaryTextColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notificationsLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: Strings.notifications.rawValue)
        label.textColor = self.secondaryTextColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var temperatureSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.onThumbText = "F"
        customSwitch.offThumbText = "C"
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        return customSwitch
    }()
    
    private lazy var windSpeedSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.onThumbText = "Km"
        customSwitch.offThumbText = "Mi"
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        return customSwitch
    }()
    
    private lazy var timeFormateSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.onThumbText = "24"
        customSwitch.offThumbText = "12"
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        return customSwitch
    }()
    
    private lazy var notificationsSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.onThumbText = "Off"
        customSwitch.offThumbText = "On"
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        return customSwitch
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .onboardingButton
        let text = String(localized: Strings.accept.rawValue)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(acceptButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var acceptButtonAction: (Bool, Bool, Bool, Bool)->Void = {_,_,_,_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightBlue
        self.layer.cornerRadius = 10
        self.setupViews()
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(self.settinsLabel)
        self.addSubview(self.temperatureLabel)
        self.addSubview(self.temperatureSwitch)
        self.addSubview(self.windSpeedLabel)
        self.addSubview(self.windSpeedSwitch)
        self.addSubview(self.timeFormatLabel)
        self.addSubview(self.timeFormateSwitch)
        self.addSubview(self.notificationsLabel)
        self.addSubview(self.notificationsSwitch)
        self.addSubview(self.acceptButton)
        
        NSLayoutConstraint.activate([
            self.settinsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            self.settinsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            self.temperatureLabel.topAnchor.constraint(equalTo: self.settinsLabel.bottomAnchor, constant: 20),
            self.temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            self.windSpeedLabel.topAnchor.constraint(equalTo: self.temperatureLabel.bottomAnchor, constant: 30),
            self.windSpeedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            self.timeFormatLabel.topAnchor.constraint(equalTo: self.windSpeedLabel.bottomAnchor, constant: 30),
            self.timeFormatLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            self.notificationsLabel.topAnchor.constraint(equalTo: self.timeFormatLabel.bottomAnchor, constant: 30),
            self.notificationsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            self.temperatureSwitch.centerYAnchor.constraint(equalTo: self.temperatureLabel.centerYAnchor),
            self.temperatureSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.temperatureSwitch.heightAnchor.constraint(equalToConstant: 30),
            self.temperatureSwitch.widthAnchor.constraint(equalToConstant: 80),
            
            self.windSpeedSwitch.centerYAnchor.constraint(equalTo: self.windSpeedLabel.centerYAnchor),
            self.windSpeedSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.windSpeedSwitch.heightAnchor.constraint(equalToConstant: 30),
            self.windSpeedSwitch.widthAnchor.constraint(equalToConstant: 80),
            
            self.timeFormateSwitch.centerYAnchor.constraint(equalTo: self.timeFormatLabel.centerYAnchor),
            self.timeFormateSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.timeFormateSwitch.heightAnchor.constraint(equalToConstant: 30),
            self.timeFormateSwitch.widthAnchor.constraint(equalToConstant: 80),
            
            self.notificationsSwitch.centerYAnchor.constraint(equalTo: self.notificationsLabel.centerYAnchor),
            self.notificationsSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.notificationsSwitch.heightAnchor.constraint(equalToConstant: 30),
            self.notificationsSwitch.widthAnchor.constraint(equalToConstant: 80),
            
            self.acceptButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.acceptButton.topAnchor.constraint(equalTo: self.notificationsLabel.bottomAnchor, constant: 42),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 40),
            self.acceptButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc private func acceptButtonDidTap() {
        let temperatureBool = self.temperatureSwitch.isOn
        let windSpeedBool = self.windSpeedSwitch.isOn
        let timeFormatBool = self.timeFormateSwitch.isOn
        let notificationsBool = self.notificationsSwitch.isOn
        
        self.acceptButtonAction(temperatureBool, windSpeedBool, timeFormatBool, notificationsBool)
    }
    
    private func setup() {
        let settings = Settings.shared
        
        self.temperatureSwitch.isOn = settings.temperature.bool
        self.windSpeedSwitch.isOn = settings.windSpeed.bool
        self.timeFormateSwitch.isOn = settings.timeFormat.bool
        self.notificationsSwitch.isOn = settings.isNotificationsOff
    }
}
