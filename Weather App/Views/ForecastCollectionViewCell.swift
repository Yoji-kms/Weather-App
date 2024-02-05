//
//  ForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Yoji on 03.02.2024.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    private lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var temperatureLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(resource: .accent).cgColor
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
        self.imageView.image = nil
        self.timeLbl.text = nil
        self.temperatureLbl.text = nil
    }
    
    func setup(with weather: Weather) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeLblTxt = dateFormatter.string(from: weather.dt)
        timeLbl.text = timeLblTxt
        
        self.temperatureLbl.text = "\(weather.main.temp)º"
        self.imageView.image = weather.weatherItem.icon
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.backView.backgroundColor = color
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.addSubview(self.timeLbl)
        self.addSubview(self.imageView)
        self.addSubview(self.temperatureLbl)
        self.addSubview(self.backView)
        
        self.sendSubviewToBack(self.backView)
        
        NSLayoutConstraint.activate([
            self.timeLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            self.timeLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 16),
            self.imageView.widthAnchor.constraint(equalToConstant: 16),
            
            self.temperatureLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.temperatureLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20),
            
            self.backView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backView.heightAnchor.constraint(equalToConstant: 84),
            self.backView.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
}
