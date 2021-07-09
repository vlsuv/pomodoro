//
//  SettingViewPresenter.swift
//  pomodoro
//
//  Created by vlsuv on 25.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol SettingViewProtocol: class {
    func update()
}

protocol SettingViewPresenterProtocol {
    init(view: SettingViewProtocol, router: RouterProtocol)
    var settings: [Setting]? { get set }
    func setupSettings()
    func showTimePicker(indexPath: IndexPath)
}

class SettingViewPresenter: SettingViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: SettingViewProtocol!
    
    var router: RouterProtocol!
    
    var settings: [Setting]?
    
    // MARK: - Init
    required init(view: SettingViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        setupSettings()
        configureObservers()
    }
    
    // MARK: - Configures
    func setupSettings() {
        let workInterval = Setting(name: "Work Interval",
                                   params: Array(1...60),
                                   selectedParam: { () -> (Int) in
                                    return UserSettings.shared.workInterval
        }) { param in
            UserSettings.shared.workInterval = param
        }
        
        
        let breakInterval = Setting(name: "Short Break",
                                    params: Array(1...30),
                                    selectedParam: { () -> (Int) in
                                        return UserSettings.shared.shortBreak
        }) { param in
            UserSettings.shared.shortBreak = param
        }
        
        let longBreakInterval = Setting(name: "Long Break",
                                        params: Array(1...60),
                                        selectedParam: { () -> (Int) in
                                            return UserSettings.shared.longBreak
        }) { param in
            UserSettings.shared.longBreak = param
        }
        
        settings = [workInterval, breakInterval, longBreakInterval]
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(forName: .didUpdateTimerSettings, object: nil, queue: nil) { [weak self] _ in
            self?.view.update()
        }
    }
    
    // MARK - Input Handlers
    func showTimePicker(indexPath: IndexPath) {
        guard let setting = settings?[indexPath.row] else { return }
        
        router.showTimePickerViewController(withSetting: setting)
    }
}
