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
    func showTimePicker()
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
        let workInterval = Setting(name: "Work Interval") { [weak self] in
            guard let self = self else { return }
            self.showTimePicker()
        }
        let shortBreak = Setting(name: "Short Break") { [weak self] in
            guard let self = self else { return }
            self.showTimePicker()
        }
        
        settings = [workInterval, shortBreak]
    }
    
    func showTimePicker() {
        router.showTimePickerViewController()
    }
}
