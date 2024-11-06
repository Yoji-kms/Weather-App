//
//  SettingsViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModelProtocol
    
    private lazy var settingsView: SettingsView = {
        let settingsView = SettingsView()
        settingsView.acceptButtonAction = self.viewModel.updateSettings
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        return settingsView
    }()
    
    private lazy var topCloudView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .cloudTop)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var middleCloudView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .cloudMiddle)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bottomCloudView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .cloudBottom)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

//    MARK: Inits
    init(viewModel: SettingsViewModelProtocol) {
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
        self.view.backgroundColor = .accent
        self.setupViews()
        self.setupNavigation()
    }
    
    private func setupViews() {
        self.view.addSubview(self.settingsView)
        self.view.addSubview(self.topCloudView)
        self.view.addSubview(self.middleCloudView)
        self.view.addSubview(self.bottomCloudView)
        
        NSLayoutConstraint.activate([
            self.settingsView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.settingsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            self.settingsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            self.settingsView.heightAnchor.constraint(equalToConstant: 330),
            
            self.topCloudView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 37),
            self.topCloudView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            
            self.middleCloudView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 121),
            self.middleCloudView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            self.bottomCloudView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -95),
            self.bottomCloudView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
