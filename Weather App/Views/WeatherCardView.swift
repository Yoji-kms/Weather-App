//
//  WeatherCardView.swift
//  Weather App
//
//  Created by Yoji on 29.10.2024.
//

import UIKit

final class WeatherCardView: UIView {
    private var weather = Weather()
    
    private lazy var partLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var parametersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .accent
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(WeatherCardTableViewCell.self, forCellReuseIdentifier: "WeatherCardTableViewCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//    MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightBlue
        self.layer.cornerRadius = 5
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with weather: Weather) {
        self.weather = weather
        self.parametersTableView.reloadData()
        
        self.iconImageView.image = weather.weatherItem.icon
        self.descriptionLabel.text = weather.weatherItem.description.capitalizedSentence
        self.temperatureLabel.text = "\(weather.main.temp.temperature)º"

        let dayString = String(localized: Strings.day.rawValue)
        let nightString = String(localized: Strings.night.rawValue)
        
        self.partLabel.text = weather.dt.isDay ? dayString : nightString
    }
    
    func setupViews() {
        self.addSubview(self.partLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.temperatureLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.parametersTableView)
        
        NSLayoutConstraint.activate([
            self.partLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.partLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            self.temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.temperatureLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 4),
            
            self.iconImageView.centerYAnchor.constraint(equalTo: self.temperatureLabel.centerYAnchor),
            self.iconImageView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -4),
            self.iconImageView.heightAnchor.constraint(equalToConstant: 32),
            self.iconImageView.widthAnchor.constraint(equalToConstant: 32),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.temperatureLabel.bottomAnchor, constant: 16),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.parametersTableView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 24),
            self.parametersTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.parametersTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.parametersTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension WeatherCardView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        46
    }
}

extension WeatherCardView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temperatureIcon: UIImage = self.weather.main.feelsLike >= 0 ? .coloredThermHot : .coloredThermCold
        
        let icon: UIImage = switch indexPath.row {
        case 0:
            temperatureIcon
        case 1:
                .coloredWind
        case 2:
                .coloredSmallCloudsRain
        case 3:
                .coloredSmallClouds
        default:
            UIImage()
        }
        
        let parameterName: String = switch indexPath.row {
        case 0:
            String(localized: Strings.feelsLike.rawValue)
        case 1:
            String(localized: Strings.wind.rawValue)
        case 2:
            String(localized: Strings.rain.rawValue)
        case 3:
            String(localized: Strings.cloudiness.rawValue)
        default:
            ""
        }
        
        let wind = self.weather.wind
        let metersPerSecond = String(localized: Strings.ms.rawValue).windSpeed
        let windString = "\(wind.speed.windSpeed) \(metersPerSecond) \(wind.windDirection)"
        
        let parameterValue: String = switch indexPath.row {
        case 0:
            "\(self.weather.main.feelsLike.temperature)º"
        case 1:
            windString
        case 2:
            "\(self.weather.main.humidity)%"
        case 3:
            "\(self.weather.clouds.all)%"
        default:
            ""
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCardTableViewCell", for: indexPath) as? WeatherCardTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }

        cell.setup(icon: icon, parameterName: parameterName, parameterValue: parameterValue)
        
        return cell
    }
}

private extension Date {
    var isDay: Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour], from: self)
        guard let hours = dateComponents.hour else { return false }
        return hours > 6 && hours <= 18
    }
}
