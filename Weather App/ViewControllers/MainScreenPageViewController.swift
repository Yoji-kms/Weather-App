//
//  MainScreenPageViewController.swift
//  Weather App
//
//  Created by Yoji on 05.02.2024.
//

import UIKit

final class MainScreenPageViewController: UIPageViewController {
    private lazy var settingsBarBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(
            image: UIImage(named: Icons.settings.rawValue),
            style: .done,
            target: self,
            action: #selector(settingsBtnBarAcion)
        )
        return btn
    }()
    
    private lazy var locationBarBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(
            image: UIImage(named: Icons.location.rawValue),
            style: .done,
            target: self,
            action: #selector(locationBtnBarAcion)
        )
        return btn
    }()
    
    init(viewControllers: [UIViewController]){
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
        self.setViewControllers(viewControllers, direction: .forward, animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Saint Petersburg"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .navigator
        self.navigationItem.leftBarButtonItem = self.settingsBarBtn
        self.navigationItem.rightBarButtonItem = self.locationBarBtn
    }
    
    //    MARK: Actions
    @objc private func settingsBtnBarAcion() {
        print("👹")
    }
    
    @objc private func locationBtnBarAcion() {
        print("🎃")
    }
}
