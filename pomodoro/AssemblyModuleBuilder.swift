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
    func createTimePickerViewController(router: RouterProtocol, viewController: SettingViewController) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createTimerViewController() -> UIViewController {
        let view = TimerViewController()
        let presenter = TimerViewPresenter(view: view, timerManager: TimerManager(), progressManager: ProgressManager())
        view.presenter = presenter
        
        view.tabBarItem.title = "Timer"
        view.tabBarItem.image = UIImage(systemName: "clock")
        
        return view
    }
    
    func createSettingsViewController(router: RouterProtocol) -> UIViewController {
        let view = SettingViewController()
        let presenter = SettingViewPresenter(view: view, router: router)
        view.presenter = presenter
        
        view.tabBarItem.title = "Settings"
        view.tabBarItem.image = UIImage(systemName: "gear")
        
        return view
    }
    
    func createTimePickerViewController(router: RouterProtocol, viewController: SettingViewController) -> UIViewController {
        let view = TimePickerViewController()
        let presenter = TimePickerViewPresenter(view: view, router: router)
        view.presenter = presenter
  
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = viewController
        
        return navigationController
    }
}
