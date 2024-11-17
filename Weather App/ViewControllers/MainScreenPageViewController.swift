//
//  MainScreenPageViewController.swift
//  Weather App
//
//  Created by Yoji on 05.02.2024.
//

import UIKit
import CoreLocation

final class MainScreenPageViewController: UIViewController {
    private let viewModel: MainScreenPageViewModelProtocol
    private var mainScreenViewControllers: [UIViewController] = []
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .black
        let circle = UIImage(systemName: "circle")
        pageControl.preferredCurrentPageIndicatorImage = circle
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.view.backgroundColor = .clear
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        return pageVC
    }()
    
    private lazy var settingsBarBtn: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .settings), for: .normal)
        button.addTarget(self, action: #selector(settingsBtnBarAcion), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)

        return barButton
    }()
    
    private lazy var locationBarBtn: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .location), for: .normal)
        button.addTarget(self, action: #selector(locationBtnBarAcion), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }()
    
    init(viewModel: MainScreenPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupNavigation()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .navigator
        self.navigationItem.leftBarButtonItem = self.settingsBarBtn
        self.navigationItem.rightBarButtonItem = self.locationBarBtn
    }
    
    private func setupViews() {
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.pageControl)
        
        self.viewModel.updateState(input: .initCity { [weak self] initialViewControllers in
            guard let self else { return }
            self.mainScreenViewControllers = initialViewControllers
            
            let firstViewController = self.mainScreenViewControllers.first
            
            if let firstMainViewController = firstViewController as? MainScreenViewController {
                firstMainViewController.delegate = self
                self.setupFirstViewController(firstMainViewController)
            } else if let firstAddViewController = firstViewController as? AddLocationViewController {
                firstAddViewController.delegate = self
                self.setupFirstViewController(firstAddViewController)
            }
        })
  
        guard let locationBarButton = self.locationBarBtn.customView else { return }
        guard let settingsBarButton = self.settingsBarBtn.customView else { return }
        
        NSLayoutConstraint.activate([
            self.pageControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            self.pageViewController.view.topAnchor.constraint(
                equalTo: self.pageControl.bottomAnchor
            ),
            self.pageViewController.view.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
            ),
            self.pageViewController.view.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
            ),
            self.pageViewController.view.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            ),
            
            locationBarButton.widthAnchor.constraint(equalToConstant: 20),
            locationBarButton.heightAnchor.constraint(equalToConstant: 26),
            
            settingsBarButton.widthAnchor.constraint(equalToConstant: 34),
            settingsBarButton.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    //    MARK: Actions
    @objc private func settingsBtnBarAcion() {
        self.viewModel.updateState(input: .settingsButtonDidTap)
    }
    
    @objc private func locationBtnBarAcion() {
        self.addLocation()
    }
    
    private func setupFirstViewController(_ viewController: UIViewController) {
        self.pageViewController.setViewControllers(
            [viewController], direction: .forward, animated: true
        )
        
        self.pageViewController.didMove(toParent: self)
    }
        
}

extension MainScreenPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard 
            let currentViewController = viewController as? MainScreenViewController,
            let currentIndex = mainScreenViewControllers.firstIndex(of: currentViewController),
            currentIndex > 0,
            let prevViewController = mainScreenViewControllers[currentIndex - 1] as? MainScreenViewController
        else { return nil }
        
        return prevViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentViewController = viewController as? MainScreenViewController,
            let currentIndex = mainScreenViewControllers.firstIndex(of: currentViewController),
            currentIndex < mainScreenViewControllers.count - 1,
            let nextViewController = mainScreenViewControllers[currentIndex + 1] as? MainScreenViewController
        else { return nil }
        
        return nextViewController
    }
}

extension MainScreenPageViewController : UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        self.pageControl.numberOfPages = self.mainScreenViewControllers.count
        return self.mainScreenViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard 
            let currentViewController = pageViewController.viewControllers?.first as? MainScreenViewController,
            let currentIndex = self.mainScreenViewControllers.firstIndex(of: currentViewController)
        else { return 0 }
        self.pageControl.currentPage = currentIndex
        
        return currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let currentViewController = pageViewController.viewControllers?.first as? MainScreenViewController,
            let currentIndex = self.mainScreenViewControllers.firstIndex(of: currentViewController)
        else { return }
        
        self.pageControl.currentPage = currentIndex
        currentViewController.delegate = self
        currentViewController.updateAll()
    }
}

extension MainScreenPageViewController: UpdateTitleDelegate {
    func updateTitle(_ title: String) {
        self.navigationItem.title = title
    }
}

extension MainScreenPageViewController: AddLocationDelegate {
    func addLocation() {
        self.viewModel.updateState(input: .locationButtonDidTap { [weak self] newMainScreenViewController in
            guard let self else { return }
            if let _ = self.pageViewController.viewControllers?.first as? AddLocationViewController {
                self.mainScreenViewControllers.removeAll()
            }
            self.mainScreenViewControllers.append(newMainScreenViewController)
            newMainScreenViewController.delegate = self
            self.pageViewController.setViewControllers([newMainScreenViewController], direction: .forward, animated: true)
        })
    }
}
