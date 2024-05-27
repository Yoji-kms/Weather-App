//
//  AddLocationViewController.swift
//  Weather App
//
//  Created by Yoji on 03.04.2024.
//

import UIKit

final class AddLocationViewController: UIViewController {
    weak var delegate: AddLocationDelegate?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "plus")?
            .applyingSymbolConfiguration(.init(pointSize: 100))
        
        button.backgroundColor = .white
        button.tintColor = .black
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.addSubview(self.button)
        
        NSLayoutConstraint.activate([
            self.button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func buttonDidTap() {
        self.delegate?.addLocation()
    }
}
