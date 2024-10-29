//
//  DailyForecastViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import DGCharts

class DailyForecastViewController: UIViewController {
    private let viewModel: DailyForecastViewModelProtocol
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            DaylyForecastTableViewCell.self,
            forCellReuseIdentifier: "DaylyForecastTableViewCell"
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.backgroundColor = .white
        tableView.separatorColor = .accent
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        button.tintColor = .black
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }()
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = String(localized: Strings.twentyFourHoursForecast.rawValue)
        return label
    }()
    
    private lazy var titleBarItem: UIBarButtonItem = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = String(localized: Strings.twentyFourHoursForecast.rawValue)
        
        let barButton = UIBarButtonItem(customView: label)
        
        return barButton
    }()
    
//    MARK: Inits
    init(viewModel: DailyForecastViewModelProtocol) {
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
        
        self.setupViews()
        self.setupNavigation()
    }
    
    private func setupViews() {
        self.view.addSubview(self.cityLabel)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.graphView)
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.cityLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.cityLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 48),
            
            self.scrollView.topAnchor.constraint(equalTo: self.cityLabel.bottomAnchor, constant: 16),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),

            self.graphView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.graphView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.graphView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.2),
            self.graphView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 16),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.cityLabel.text = self.viewModel.forecast.city.name
        self.graphView.setup(with: self.viewModel.forecast)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .systemGray
        self.navigationItem.leftBarButtonItems = [self.backBarButton, self.titleBarItem]
    }
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DailyForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

extension DailyForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = self.viewModel.forecast.list[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaylyForecastTableViewCell", for: indexPath) as? DaylyForecastTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.clipsToBounds = true
        cell.setup(with: weather)
        
        return cell
    }
}
