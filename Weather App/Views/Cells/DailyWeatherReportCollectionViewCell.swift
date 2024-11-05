//
//  DailyWeatherReportCollectionViewCell.swift
//  Weather App
//
//  Created by Yoji on 29.10.2024.
//

import UIKit

final class DailyWeatherReportCollectionViewCell: UICollectionViewCell {
//    MARK: Views
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//  MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.dateLabel.text = nil
    }
    
//    MARK: Setups
    private func setupViews() {
        self.addSubview(self.backView)
        self.addSubview(self.dateLabel)
        self.sendSubviewToBack(self.backView)
        
        NSLayoutConstraint.activate([
            self.backView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backView.widthAnchor.constraint(equalToConstant: 88),
            self.backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.dateLabel.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 8),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.backView.centerXAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -8)
        ])
    }
    
    func setup(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM EE"
        let text = dateFormatter.string(from: date).uppercased()
        self.dateLabel.text = text
    }
    
//     MARK: Methods
    func changeColors(isSelected: Bool) {
        if isSelected {
            self.backView.backgroundColor = .accent
            self.dateLabel.textColor = .white
        } else {
            self.backView.backgroundColor = .white
            self.dateLabel.textColor = .black
        }
    }
}
