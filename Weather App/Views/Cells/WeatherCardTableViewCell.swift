//
//  WeatherCardTableViewCell.swift
//  Weather App
//
//  Created by Yoji on 29.10.2024.
//

import UIKit

final class WeatherCardTableViewCell: UITableViewCell {
//    MARK: Views
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var parameterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var parameterValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
// MARK: Lifecycle
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.parameterNameLabel.text = nil
        self.parameterValueLabel.text = nil
    }
    
//    MARK: Setups
    private func setupViews() {
        self.addSubview(self.iconImageView)
        self.addSubview(self.parameterNameLabel)
        self.addSubview(self.parameterValueLabel)
        
        NSLayoutConstraint.activate([
            self.iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            self.parameterNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.parameterNameLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 16),
            
            self.parameterValueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.parameterValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func setup(icon: UIImage, parameterName: String, parameterValue: String) {
        self.iconImageView.image = icon
        self.parameterNameLabel.text = parameterName
        self.parameterValueLabel.text = parameterValue
    }
}
