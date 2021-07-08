//
//  AssemblyModuleBuilder.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol AssemblyModuleBuilderProtocol {
    func createTimerViewController() -> UIViewController
    func createSettingsViewController(router: RouterProtocol) -> UIViewController
    func createTimePickerViewController(router: RouterProtocol, setting: Setting) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createTimerViewController() -> UIViewController {
        let view = TimerViewController()
        let presenter = TimerViewPresenter(view: view)
        view.presenter = presenter
        let navController = createNavController(rootViewController: view, title: "Timer", image: Images.clock)
        return navController
    }
    
    func createSettingsViewController(router: RouterProtocol) -> UIViewController {
        let view = SettingViewController()
        let presenter = SettingViewPresenter(view: view, router: router)
        view.presenter = presenter
        let navController = createNavController(rootViewController: view, title: "Settings", image: Images.settings)
        return navController
    }
    
    func createTimePickerViewController(router: RouterProtocol, setting: Setting) -> UIViewController {
        let view = TimePickerViewController()
        let presenter = TimePickerViewPresenter(view: view, router: router, setting: setting)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}

extension AssemblyModuleBuilder {
    private func createNavController(rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
