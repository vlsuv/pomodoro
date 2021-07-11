//
//  Router.swift
//  pomodoro
//
//  Created by vlsuv on 25.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol BaseRouterProtocol {
    var tabBarController: UITabBarController? { get set }
    var assemblyModuleBuilder: AssemblyModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: BaseRouterProtocol {
    func initilizationViewController()
    func showTimePickerViewController(withSetting setting: StaticSettingOption)
}

class Router: RouterProtocol {
    var tabBarController: UITabBarController?
    var assemblyModuleBuilder: AssemblyModuleBuilderProtocol?
    
    init(tabBarController: UITabBarController, assemblyModuleBuilder: AssemblyModuleBuilderProtocol) {
        self.tabBarController = tabBarController
        self.assemblyModuleBuilder = assemblyModuleBuilder
    }
    
    func initilizationViewController() {
        guard let tabBarController = tabBarController else { return }
        if let timerViewController = assemblyModuleBuilder?.createTimerViewController(), let settingsViewController = assemblyModuleBuilder?.createSettingsViewController(router: self) {
            tabBarController.viewControllers = [timerViewController, settingsViewController]
        }
    }
    
    func showTimePickerViewController(withSetting setting: StaticSettingOption) {
        guard let tabBarController = tabBarController, let timePickerViewController = assemblyModuleBuilder?.createTimePickerViewController(router: self, setting: setting) else { return }
        
        timePickerViewController.modalPresentationStyle = .custom
        timePickerViewController.transitioningDelegate = tabBarController
        
        tabBarController.present(timePickerViewController, animated: true, completion: nil)
    }
}
