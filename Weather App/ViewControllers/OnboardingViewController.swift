//
//  OnboardingViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    private let viewModel: OnboardingViewModelProtocol
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(resource: .onboarding)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .onboardingButton
        let text = String(localized: Strings.acceptGeo.rawValue)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(acceptButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var denyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let text = String(localized: Strings.denyGeo.rawValue)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(denyButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        let text = String(localized: Strings.onboardingTop.rawValue)
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        let middleText = String(localized: Strings.onboardingMiddle.rawValue)
        let bottomText = String(localized: Strings.onboardingBottom.rawValue)
        let text = "\(middleText)\n\n\(bottomText)"
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    MARK: Actions
    @objc private func acceptButtonDidTap() {
        self.viewModel.updateState(input: .acceptDidTap)
    }
    
    @objc private func denyButtonDidTap() {
        self.viewModel.updateState(input: .denyDidTap)
    }

//    MARK: Inits
    init(viewModel: OnboardingViewModelProtocol) {
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
        self.view.backgroundColor = UIColor(resource: .accent)
        self.setupViews()
    }
    
//    MARK: Setups
    private func setupViews() {
        self.view.addSubview(self.acceptButton)
        self.view.addSubview(self.denyButton)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.topLabel)
        self.view.addSubview(self.bottomLabel)
        
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),
            self.imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            self.imageView.bottomAnchor.constraint(equalTo: self.topLabel.topAnchor, constant: -80),
            
            self.topLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.topLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.topLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            self.bottomLabel.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 40),
            self.bottomLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.bottomLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            self.acceptButton.topAnchor.constraint(equalTo: self.bottomLabel.bottomAnchor, constant: 40),
            self.acceptButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.acceptButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.denyButton.topAnchor.constraint(equalTo: self.acceptButton.bottomAnchor, constant: 16),
            self.denyButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.denyButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
