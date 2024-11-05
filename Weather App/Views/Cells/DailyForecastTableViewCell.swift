//
//  Untitled.swift
//  Weather App
//
//  Created by Yoji on 23.10.2024.
//
import UIKit

final class DailyForecastTableViewCell: UITableViewCell {
    let primaryTextColor: UIColor = .black
    let secondaryTextColor: UIColor = .systemGray
    
    let primaryFont: UIFont = .systemFont(ofSize: 14)
    let primaryBoldFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = primaryBoldFont
        label.textColor = primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = primaryFont
        label.textColor = secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = primaryBoldFont
        label.textColor = primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.showsExpansionTextWhenTruncated = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = primaryFont
        label.textColor = primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = primaryTextColor

        let windImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredWind))
        windImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 15, height: 10)
        let windText = String(localized: Strings.wind.rawValue)

        let attributedText = windText.with(attachment: windImgAtchmnt)
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = secondaryTextColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = primaryTextColor
        let humidityImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredSmallRain))
        humidityImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 11, height: 13)
        let humidityText = String(localized: Strings.humidity.rawValue)

        let attributedText = humidityText.with(attachment: humidityImgAtchmnt)
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = secondaryTextColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cloudsLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = primaryTextColor
        
        let cloudsImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredSmallClouds))
        cloudsImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 14, height: 10)
        let cloudsText = String(localized: Strings.cloudiness.rawValue)

        let attributedText = cloudsText.with(attachment: cloudsImgAtchmnt)
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cloudsValueLabel: UILabel = {
        let label = UILabel()
        label.font = primaryFont
        label.textColor = secondaryTextColor
        label.textAlignment = .right
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
        self.setupViews()
        self.backgroundColor = .lightBlue
    }
    
    override func prepareForReuse() {
        self.dateLabel.text = nil
        self.timeLabel.text = nil
        self.temperatureLabel.text = nil
        self.descriptionLabel.attributedText = nil
        self.feelsLikeLabel.text = nil
        self.windValueLabel.text = nil
        self.humidityValueLabel.text = nil
        self.cloudsValueLabel.text = nil
    }
        
    func setup(with weather: Weather) {
        let dateLabelText = weather.dateText
        let timeLabelText = weather.timeText
        let temperatureLabelText = weather.temperatureText
        let descriptionLabelText = weather.weatherItem.description.capitalizedSentence
        let descriptionIcon = weather.weatherItem.icon
        let feelsLikeLabelText = weather.feelsLikeText
        let windLabelText = weather.windText
        let humidityLabelText = weather.humidityText
        let cloudsLabelText = weather.cloudsText
        
        let descriptionAttachment = NSTextAttachment(image: descriptionIcon)
        descriptionAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let descriptionAttributedText = descriptionLabelText.with(attachment: descriptionAttachment)
        
        self.dateLabel.text = dateLabelText
        self.timeLabel.text = timeLabelText
        self.temperatureLabel.text = temperatureLabelText
        self.descriptionLabel.attributedText = descriptionAttributedText
        self.feelsLikeLabel.text = feelsLikeLabelText
        self.windValueLabel.text = windLabelText
        self.humidityValueLabel.text = humidityLabelText
        self.cloudsValueLabel.text = cloudsLabelText
    }
    
    private func setupViews() {
        self.addSubview(self.dateLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.temperatureLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.feelsLikeLabel)
        self.addSubview(self.windLabel)
        self.addSubview(self.windValueLabel)
        self.addSubview(self.humidityLabel)
        self.addSubview(self.humidityValueLabel)
        self.addSubview(self.cloudsLabel)
        self.addSubview(self.cloudsValueLabel)
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            self.timeLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 8),
            self.timeLabel.widthAnchor.constraint(equalToConstant: 64),
            
            self.temperatureLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 8),
            self.temperatureLabel.widthAnchor.constraint(equalToConstant: 64),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 8),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            
            self.feelsLikeLabel.leadingAnchor.constraint(equalTo: self.descriptionLabel.trailingAnchor),
            self.feelsLikeLabel.bottomAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor),
            
            self.windLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 8),
            self.windLabel.leadingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor),
            
            self.windValueLabel.bottomAnchor.constraint(equalTo: self.windLabel.bottomAnchor),
            self.windValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.humidityLabel.topAnchor.constraint(equalTo: self.windLabel.bottomAnchor, constant: 8),
            self.humidityLabel.leadingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor),
            
            self.humidityValueLabel.bottomAnchor.constraint(equalTo: self.humidityLabel.bottomAnchor),
            self.humidityValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.cloudsLabel.topAnchor.constraint(equalTo: self.humidityLabel.bottomAnchor, constant: 8),
            self.cloudsLabel.leadingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor),
            
            self.cloudsValueLabel.bottomAnchor.constraint(equalTo: self.cloudsLabel.bottomAnchor),
            self.cloudsValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
}

private extension Weather {
    var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd/MM"
        let txt = dateFormatter.string(from: self.dt)
        return txt
    }
    
    var timeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let txt = dateFormatter.string(from: self.dt)
        return txt
    }
    
    var temperatureText: String {
        return "\(self.main.temp)º"
    }
    
    var feelsLikeText: String {
        let feelsLikeString = String(localized: Strings.feelsLike.rawValue)
        return "\(feelsLikeString) \(self.main.feelsLike)º"
    }
    
    var windText: String {
        let metersPerSecond = String(localized: Strings.ms.rawValue)
        let direction = self.wind.windDirection
        let speed = self.wind.speed
        return "\(speed) \(metersPerSecond) \(direction)"
    }
    
    var humidityText: String {
        return "\(self.main.humidity)%"
    }
    
    var cloudsText: String {
        return "\(self.clouds.all)%"
    }
}

private extension String {
    func with(attachment: NSTextAttachment) -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(attachment: attachment))
        attributedText.append(NSAttributedString(string: " \(self)"))
        return attributedText
    }
}
