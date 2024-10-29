//
//  DaylyForecastTableViewCell.swift
//  Weather App
//
//  Created by Yoji on 04.02.2024.
//

import UIKit

final class DaylyForecastMainTableViewCell: UITableViewCell {
    private lazy var dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .systemGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private lazy var humidityLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = UIColor(resource: .accent)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private lazy var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private lazy var temperatureLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
// MARK: Lifecycle
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    override func prepareForReuse() {
        self.dateLbl.text = nil
        self.humidityLbl.text = nil
        self.descriptionLbl.text = nil
        self.temperatureLbl.text = nil
    }
    
    func setup(with forecast: Forecast, date: Date) {
        let dateLblTxt = self.getDateLblTxt(date)
        let humidityLblTxt = forecast.getParameterByDate(date, parameter: .humidity)
        let descriptionLblTxt = forecast.getDescriptionByDate(date)
        let temperatureLblTxt = forecast.getParameterByDate(date, parameter: .temperature)
        
        self.dateLbl.text = dateLblTxt
        self.humidityLbl.attributedText = humidityLblTxt
        self.descriptionLbl.text = descriptionLblTxt
        self.temperatureLbl.attributedText = temperatureLblTxt
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .lightBlue
        
        self.addSubview(self.dateLbl)
        self.addSubview(self.humidityLbl)
        self.addSubview(self.descriptionLbl)
        self.addSubview(self.temperatureLbl)
        
        
        NSLayoutConstraint.activate([
            self.dateLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.dateLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            self.humidityLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.humidityLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            self.descriptionLbl.leadingAnchor.constraint(equalTo: self.dateLbl.trailingAnchor, constant: 16),
            self.descriptionLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.descriptionLbl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55),
            
            self.temperatureLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.temperatureLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func getDateLblTxt(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let txt = dateFormatter.string(from: date)
        return txt
    }
}

extension Forecast {
    enum Parameters {
        case humidity
        case temperature
    }
    
    func getDescriptionByDate(_ date: Date) -> String {
        let daylyWeathers = self.list.filter { $0.dt.isEqualWithDate(date) }
        
        let daylyWeathersContainsMidday = daylyWeathers.contains(where: { $0.dt.isMidday })
        let weather = daylyWeathersContainsMidday ? daylyWeathers.filter { $0.dt.isMidday }.last : daylyWeathers.last
        return weather?.weatherItem.description.capitalizedSentence ?? ""
    }
    
    func getParameterByDate(_ date: Date, parameter: Parameters) -> NSAttributedString {
        let daylyWeathers = self.list.filter { $0.dt.isEqualWithDate(date) }
        
        switch parameter {
        case .humidity:
            var sumHumidity: Int = 0
            daylyWeathers.compactMap { $0.main.humidity }.forEach { humidity in
                sumHumidity += humidity
            }
            let averageHumidity = sumHumidity / daylyWeathers.count
            
            let humidityImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredSmallRain))
            humidityImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
            
            let humidityTxt = NSMutableAttributedString()
            humidityTxt.append(NSAttributedString(attachment: humidityImgAtchmnt))
            humidityTxt.append(NSAttributedString(string: " \(averageHumidity)%"))
            return humidityTxt
        case .temperature:
            let temperatureTxt = NSMutableAttributedString()
            if daylyWeathers.count == 1 {
                temperatureTxt.append(NSAttributedString(
                    string: "\(daylyWeathers.first?.main.temp ?? 0)º ")
                )
            } else {
                var minTemp = daylyWeathers.first?.main.temp ?? 0
                var maxTemp = minTemp
                daylyWeathers.forEach { weather in
                    let temperature = weather.main.temp
                    minTemp = temperature < minTemp ? temperature : minTemp
                    maxTemp = temperature > maxTemp ? temperature : maxTemp
                }
                temperatureTxt.append(NSAttributedString(string: "\(minTemp)º..\(maxTemp)º "))
            }
            let arrowAttachment = NSTextAttachment(
                image: UIImage(systemName: "chevron.right") ?? UIImage()
            )
            arrowAttachment.bounds = CGRect(x: 0, y: 0, width: 6, height: 9.5)
            temperatureTxt.append(NSAttributedString(attachment: arrowAttachment))
            return temperatureTxt
        }
    }
}
