//
//  MainScreenViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

final class MainScreenViewController: UIViewController {
    private let viewModel: MainScreenViewModelProtocol
    
//    MARK: Views
    private lazy var scrollView: UIScrollView = {
        let scrl = UIScrollView()
        scrl.backgroundColor = .white
        scrl.isScrollEnabled = true
        scrl.automaticallyAdjustsScrollIndicatorInsets = true
        scrl.translatesAutoresizingMaskIntoConstraints = false
        return scrl
    }()
    
//    private lazy var settingsBarBtn: UIBarButtonItem = {
//        let btn = UIBarButtonItem(
//            image: UIImage(named: Icons.settings.rawValue),
//            style: .done,
//            target: self,
//            action: #selector(settingsBtnBarAcion)
//        )
//        return btn
//    }()
//    
//    private lazy var locationBarBtn: UIBarButtonItem = {
//        let btn = UIBarButtonItem(
//            image: UIImage(named: Icons.location.rawValue),
//            style: .done,
//            target: self,
//            action: #selector(locationBtnBarAcion)
//        )
//        return btn
//    }()
    
    private lazy var mainView: MainView = {
        let view = MainView()
        view.setup(with: self.viewModel.weather)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var forecastCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var forecastCollectionView: UICollectionView = {
        let colView = UICollectionView(frame: .zero, collectionViewLayout: forecastCollectionViewLayout)
        colView.register(
            ForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: "ForecastCollectionViewCell"
        )
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        colView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        colView.dataSource = self
        colView.delegate = self
        colView.translatesAutoresizingMaskIntoConstraints = false
        return colView
    }()
    
    private lazy var daylyForecastTableView: UITableView = {
        let tblView = UITableView(frame: .zero, style: .insetGrouped)
        tblView.register(
            DaylyForecastTableViewCell.self,
            forCellReuseIdentifier: "DaylyForecastTableViewCell"
        )
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tblView.backgroundColor = .white
        tblView.isScrollEnabled = false
        tblView.delegate = self
        tblView.dataSource = self
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    //    MARK: Inits
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
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

//        self.setupNavigation()
        self.setupViews()
    }
    
//    MARK: Setups
    private func setupViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.mainView)
        self.scrollView.addSubview(self.forecastCollectionView)
        self.scrollView.addSubview(self.daylyForecastTableView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.mainView.topAnchor
                .constraint(equalTo: self.scrollView.topAnchor, constant: 16),
            self.mainView.leadingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.mainView.trailingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.mainView.heightAnchor.constraint(equalToConstant: 212),
            
            self.forecastCollectionView.topAnchor
                .constraint(equalTo: self.mainView.bottomAnchor,constant: 32),
            self.forecastCollectionView.leadingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.forecastCollectionView.trailingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.forecastCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            self.daylyForecastTableView.topAnchor
                .constraint(equalTo: self.forecastCollectionView.bottomAnchor, constant: 16),
            self.daylyForecastTableView.leadingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.daylyForecastTableView.trailingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.daylyForecastTableView.bottomAnchor
                .constraint(equalTo: self.scrollView.bottomAnchor),
            self.daylyForecastTableView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
//    private func setupNavigation() {
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.title = "Saint Petersburg"
//        self.navigationController?.navigationBar.tintColor = .black
//        self.navigationItem.style = .navigator
//        self.navigationItem.leftBarButtonItem = self.settingsBarBtn
//        self.navigationItem.rightBarButtonItem = self.locationBarBtn
//    }
    
////    MARK: Actions
//    @objc private func settingsBtnBarAcion() {
//        self.viewModel.updateStateNet(request: .updateTemperature{
//            DispatchQueue.main.sync {
//                self.mainView.setup(with: self.viewModel.weather)
//                self.forecastCollectionView.reloadData()
//            }
//        })
//    }
//    
//    @objc private func locationBtnBarAcion() {
//        print("🎃")
//    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? ForecastCollectionViewCell)?
            .changeBackgroundColor(UIColor(resource: .accent))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? ForecastCollectionViewCell)?
            .changeBackgroundColor(.white)
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.forecast.list.count < 8 ? self.viewModel.forecast.list.count : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.setup(with: self.viewModel.forecast.list[indexPath.row])
        
        return cell
    }
}

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension MainScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.forecast.dates.uniqueDatesWithoutCurrent().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dates = self.viewModel.forecast.dates.uniqueDatesWithoutCurrent()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaylyForecastTableViewCell", for: indexPath) as? DaylyForecastTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.clipsToBounds = true
        cell.setup(with: self.viewModel.forecast, date: dates[indexPath.section])
        
        return cell
    }
}
