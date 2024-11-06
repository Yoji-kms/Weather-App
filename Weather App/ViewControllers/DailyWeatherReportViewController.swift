//
//  DailyWeatherReportViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

class DailyWeatherReportViewController: UIViewController {
    private let viewModel: DailyWeatherReportViewModelProtocol
    private var selectedDateId: Int
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        button.tintColor = .black
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }()
    
    private lazy var titleBarItem: UIBarButtonItem = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = String(localized: Strings.dailyWeather.rawValue)
        
        let barButton = UIBarButtonItem(customView: label)
        
        return barButton
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.text = self.viewModel.city
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datesCollectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 88, height: 36)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var datesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: self.datesCollectionViewLayout
        )
        
        collectionView.register(
            DailyWeatherReportCollectionViewCell.self,
            forCellWithReuseIdentifier: "DailyWeatherReportCollectionViewCell"
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "DefaultCell"
        )
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var notEnoughDataLabel: UILabel = {
        let label = UILabel()
        
        let text = String(localized: Strings.notEnoughData.rawValue)
        label.text = text
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.isHidden = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dayWeatherCardView: WeatherCardView = {
        let cardView = WeatherCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    
    private lazy var nightWeatherCardView: WeatherCardView = {
        let cardView = WeatherCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

//    MARK: Inits
    init(viewModel: DailyWeatherReportViewModelProtocol, selectedDateId: Int) {
        self.viewModel = viewModel
        self.selectedDateId = selectedDateId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.setupNavigation()
        let indexPath = IndexPath(row: self.selectedDateId, section: 0)
        self.datesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        self.updateWeatherCards(dateId: self.selectedDateId)
    }
    
    private func setupViews() {
        self.view.addSubview(self.cityLabel)
        self.view.addSubview(self.datesCollectionView)
        self.view.addSubview(self.notEnoughDataLabel)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.dayWeatherCardView)
        self.scrollView.addSubview(self.nightWeatherCardView)
        self.view.sendSubviewToBack(self.notEnoughDataLabel)
        
        NSLayoutConstraint.activate([
            self.cityLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.cityLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            self.notEnoughDataLabel.topAnchor.constraint(equalTo: self.datesCollectionView.bottomAnchor, constant: 40),
            self.notEnoughDataLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.notEnoughDataLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            self.datesCollectionView.topAnchor.constraint(equalTo: self.cityLabel.bottomAnchor, constant: 32),
            self.datesCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.datesCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.datesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            self.scrollView.topAnchor.constraint(equalTo: self.datesCollectionView.bottomAnchor, constant: 40),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.dayWeatherCardView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.dayWeatherCardView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.dayWeatherCardView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.dayWeatherCardView.heightAnchor.constraint(equalToConstant: 308),
            
            self.nightWeatherCardView.topAnchor.constraint(equalTo: self.dayWeatherCardView.bottomAnchor, constant: 16),
            self.nightWeatherCardView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.nightWeatherCardView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.nightWeatherCardView.heightAnchor.constraint(equalToConstant: 308),
            self.nightWeatherCardView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .systemGray
        self.navigationItem.leftBarButtonItems = [self.backBarButton, self.titleBarItem]
    }
    
    @objc private func backButtonDidTap() {
        self.viewModel.popViewController()
    }
    
    private func updateWeatherCards(dateId: Int) {
        self.viewModel.updateWeatherBy(dateId: dateId) { dailyWeather in
            guard let dailyWeather else {
                self.dayWeatherCardView.visibility(gone: true)
                self.nightWeatherCardView.visibility(gone: true)
                self.notEnoughDataLabel.isHidden = false
                return
            }
            
            self.dayWeatherCardView.visibility(gone: false, dimension: 308)
            self.dayWeatherCardView.setup(with: dailyWeather.dayWeather)
            
            guard let nightWeather = dailyWeather.nightWeather else {
                self.nightWeatherCardView.visibility(gone: true)
                return
            }
            
            self.nightWeatherCardView.visibility(gone: false, dimension: 308)
            self.nightWeatherCardView.setup(with: nightWeather)
            self.notEnoughDataLabel.isHidden = true
        }
    }
}

extension DailyWeatherReportViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? DailyWeatherReportCollectionViewCell)?
            .changeColors(isSelected: true)
        let dateId = indexPath.row
        self.updateWeatherCards(dateId: dateId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? DailyWeatherReportCollectionViewCell)?
            .changeColors(isSelected: false)
    }
}

extension DailyWeatherReportViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyWeatherReportCollectionViewCell", for: indexPath) as? DailyWeatherReportCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.setup(with: self.viewModel.dates[indexPath.row])
        if cell.isSelected {
            cell.changeColors(isSelected: true)
        }
        
        return cell
    }
}
