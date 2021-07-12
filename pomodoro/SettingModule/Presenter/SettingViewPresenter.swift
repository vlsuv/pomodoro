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
    var settings: [SettingSection] { get set }
    func didTapSetting(at indexPath: IndexPath)
}

class SettingViewPresenter: SettingViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: SettingViewProtocol!
    
    var router: RouterProtocol!
    
    var settings: [SettingSection] = [SettingSection]()
    
    // MARK: - Init
    required init(view: SettingViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        setupSettings()
        configureObservers()
    }
    
    // MARK: - Configures
    private func setupSettings() {
        let workInterval = TimeSettingOption(title: "Work Interval",
                                             params: Array(1...60),
                                             abbreviation: "min",
                                             selectedParam: { () -> (Int) in
                                                return UserSettings.shared.workInterval
        }) { param in
            UserSettings.shared.workInterval = param
        }
        
        let shortBreak = TimeSettingOption(title: "Short Break",
                                           params: Array(1...30),
                                           abbreviation: "min",
                                           selectedParam: { () -> (Int) in
                                            return UserSettings.shared.shortBreak
        }) { param in
            UserSettings.shared.shortBreak = param
        }
        
        let longBreak = TimeSettingOption(title: "Long Break",
                                          params: Array(1...60),
                                          abbreviation: "min",
                                          selectedParam: { () -> (Int) in
                                            return UserSettings.shared.longBreak
        }) { param in
            UserSettings.shared.longBreak = param
        }
        
        let longBreakAfter = TimeSettingOption(title: "Long Break After",
                                               params: Array(1...10),
                                               abbreviation: "intervals",
                                               selectedParam: { () -> (Int) in
                                                return UserSettings.shared.longBreakAfter
        },
                                               completionHandler: { param in
                                                UserSettings.shared.longBreakAfter = param
        })
        
        let taskGoal = TimeSettingOption(title: "Task Goal",
                                         params: Array(1...6),
                                         abbreviation: "intervals",
                                         selectedParam: { () -> (Int) in
                                            return UserSettings.shared.taskGoal
        },
                                         completionHandler: { param in
                                            UserSettings.shared.taskGoal = param
        })
        
        let timerSection = SettingSection(title: "TIME", option: [
            .timeCell(model: workInterval),
            .timeCell(model: shortBreak),
            .timeCell(model: longBreak),
            .timeCell(model: longBreakAfter),
            .timeCell(model: taskGoal)
        ])
        
        let reminders = SwitchSettingOption(title: "Reminders",
                                            handler: {
                                                UserSettings.shared.reminders.toggle()
        },
                                            isOn: UserSettings.shared.reminders)
        
        let theme = SwitchSettingOption(title: "Dark Mode",
                                        handler: {
                                            UserSettings.shared.darkMode.toggle()
                                            
                                            UIApplication.shared.windows.forEach { window in
                                                window.overrideUserInterfaceStyle = UserSettings.shared.darkMode ? .dark : .light
                                            }
        },
                                        isOn: UserSettings.shared.darkMode)
        
        let generalSection = SettingSection(title: "GENERAL", option: [
            .switchCell(model: reminders),
            .switchCell(model: theme)
        ])
        
        settings = [timerSection, generalSection]
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(forName: .didUpdateTimerSettings, object: nil, queue: nil) { [weak self] _ in
            self?.view.update()
        }
    }
    
    // MARK - Input Handlers
    func didTapSetting(at indexPath: IndexPath) {
        let setting = settings[indexPath.section].option[indexPath.row]
        
        switch setting {
        case .timeCell(model: let model):
            router.showTimePickerViewController(withSetting: model)
        case .switchCell(model: let model):
            model.handler?()
        }
    }
}
