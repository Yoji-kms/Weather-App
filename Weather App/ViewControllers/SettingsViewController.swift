//
//  SettingsViewController.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModelProtocol

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
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemRed
    }
}
