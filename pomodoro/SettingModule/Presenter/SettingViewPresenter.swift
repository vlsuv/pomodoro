//
//  SettingViewPresenter.swift
//  pomodoro
//
//  Created by vlsuv on 25.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol SettingViewProtocol: class {
    
}

protocol SettingViewPresenterProtocol {
    init(view: SettingViewProtocol, router: RouterProtocol)
    var settings: [Setting]? { get set }
    func setupSettings()
    func showTimePicker(indexPath: IndexPath)
}

class SettingViewPresenter: SettingViewPresenterProtocol {
    weak var view: SettingViewProtocol!
    var router: RouterProtocol!
    var settings: [Setting]?
    
    required init(view: SettingViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        setupSettings()
    }
    
    func setupSettings() {
        let workInterval = Setting(name: "Work Interval", params: [1500, 1800, 2100, 2400]) { param in
            print("Work Interval save: \(param)")
            UserSettings.shared.workInterval = param
        }
        
        let breakInterval = Setting(name: "Break Interval", params: [300, 600]) { param in
            print("Break Interval save: \(param)")
            UserSettings.shared.breakInterval = param
        }
        
        settings = [workInterval, breakInterval]
    }
    
    func showTimePicker(indexPath: IndexPath) {
        guard let setting = settings?[indexPath.row] else { return }
        router.showTimePickerViewController(withSetting: setting)
    }
}
