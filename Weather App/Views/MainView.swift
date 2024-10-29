//
//  MainView.swift
//  Weather App
//
//  Created by Yoji on 07.12.2023.
//

import UIKit

final class MainView: UIView {
    private lazy var sunriseImg: UIImageView = {
        let img = UIImage(resource: .sunrise)
        let imgView = UIImageView(image: img)
        imgView.tintColor = UIColor(resource: .darkYellow)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var sunsetImg: UIImageView = {
        let img = UIImage(resource: .sunset)
        let imgView = UIImageView(image: img)
        imgView.tintColor = UIColor(resource: .darkYellow)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var minMaxTempLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var currentTempLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 36, weight: .bold)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var curveView: CurveView = {
        let curveView = CurveView()
        curveView.translatesAutoresizingMaskIntoConstraints = false
        return curveView
    }()
    
    private lazy var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sunsetLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sunriseLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var dateTimeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = UIColor(resource: .darkYellow)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var parametersLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
//    MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(resource: .accent)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setups
    func setup(with weather: Weather) {
        let minMaxTemperatureTxt = "\(weather.main.tempMin)º/\(weather.main.tempMax)º"
        let currentTemperatureTxt = "\(weather.main.temp)º"
        let descriptionTxt = weather.weatherItem.description.capitalizedSentence
        let parametersTxt = self.getParametersText(weather: weather)
        let sunriseTxt = self.getSunsetSunriseTextFormatted(date: weather.sys?.sunrise)
        let sunsetTxt = self.getSunsetSunriseTextFormatted(date: weather.sys?.sunset)
        let dateTimeTxt = self.getCurrentDateFormatted()
        
        self.minMaxTempLbl.text = minMaxTemperatureTxt
        self.currentTempLbl.text = currentTemperatureTxt
        self.descriptionLbl.text = descriptionTxt
        self.parametersLbl.attributedText = parametersTxt
        self.sunriseLbl.text = sunriseTxt
        self.sunsetLbl.text = sunsetTxt
        self.dateTimeLbl.text = dateTimeTxt
    }
    
    private func setupViews() {
        self.addSubview(minMaxTempLbl)
        self.addSubview(currentTempLbl)
        self.addSubview(sunriseLbl)
        self.addSubview(sunsetLbl)
        self.addSubview(descriptionLbl)
        self.addSubview(dateTimeLbl)
        self.addSubview(parametersLbl)
        
        self.addSubview(sunriseImg)
        self.addSubview(sunsetImg)
        
        self.addSubview(self.curveView)
        self.sendSubviewToBack(self.curveView)
        
        NSLayoutConstraint.activate([
            curveView.topAnchor.constraint(equalTo: self.topAnchor),
            curveView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            curveView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            curveView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            minMaxTempLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            minMaxTempLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            currentTempLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTempLbl.topAnchor.constraint(equalTo: minMaxTempLbl.bottomAnchor, constant: 8),
            
            descriptionLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLbl.topAnchor.constraint(equalTo: currentTempLbl.bottomAnchor, constant: 8),
            
            parametersLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            parametersLbl.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 16),
            parametersLbl.heightAnchor.constraint(equalToConstant: 16),
            
            dateTimeLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateTimeLbl.topAnchor.constraint(equalTo: parametersLbl.bottomAnchor, constant: 16),
            
            sunriseLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            sunriseLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            
            sunriseImg.centerXAnchor.constraint(equalTo: sunriseLbl.centerXAnchor),
            sunriseImg.bottomAnchor.constraint(equalTo: sunriseLbl.topAnchor, constant: -4),
            sunriseImg.widthAnchor.constraint(equalToConstant: 17),
            sunriseImg.heightAnchor.constraint(equalToConstant: 17),
            
            sunsetLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sunsetLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            
            sunsetImg.centerXAnchor.constraint(equalTo: sunsetLbl.centerXAnchor),
            sunsetImg.bottomAnchor.constraint(equalTo: sunsetLbl.topAnchor, constant: -4),
            sunsetImg.widthAnchor.constraint(equalToConstant: 17),
            sunsetImg.heightAnchor.constraint(equalToConstant: 17),
        ])
    }
    
    private func getParametersText(weather: Weather) -> NSAttributedString {
        let humidityImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredHumidityLight))
        humidityImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 13, height: 15)
        let windImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredWindLight))
        windImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 25, height: 16)
        let cloudsImgAtchmnt = NSTextAttachment(image: UIImage(resource: .coloredCloudsSun))
        cloudsImgAtchmnt.bounds = CGRect(x: 0, y: 0, width: 21, height: 18)
        
        let metersForSecond = String(localized: Strings.ms.rawValue)
        let parametersTxt = NSMutableAttributedString()
        parametersTxt.append(NSAttributedString(attachment: cloudsImgAtchmnt))
        parametersTxt.append(NSAttributedString(
            string: " \(weather.clouds.all)   ")
        )
        
        parametersTxt.append(NSAttributedString(attachment: windImgAtchmnt))
        parametersTxt.append(NSAttributedString(
            string: " \(weather.wind.speed) \(metersForSecond)   ")
        )
        
        parametersTxt.append(NSAttributedString(attachment: humidityImgAtchmnt))
        parametersTxt.append(NSAttributedString(string: " \(weather.main.humidity)%"))
        
        return parametersTxt
    }
    
    private func getSunsetSunriseTextFormatted(date: Date?) -> String {
        let sunsetSunriseFormatter = DateFormatter()
        sunsetSunriseFormatter.dateFormat = "HH:mm"
        let txt = sunsetSunriseFormatter.string(from: date ?? Date())
        return txt
    }
    
    private func getCurrentDateFormatted() -> String {
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.locale = Locale.current
        
        currentDateFormatter.dateFormat = "HH:mm, EE dd MMMM"
        let currentDate = Date()
        let txt = currentDateFormatter.string(from: currentDate)
        return txt
    }
}
