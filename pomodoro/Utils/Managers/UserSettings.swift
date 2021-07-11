//
//  UserSettings.swift
//  pomodoro
//
//  Created by vlsuv on 01.03.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

final class UserSettings {
    
    private init() {}
    static var shared = UserSettings()
    
    private enum settingKeys: String {
        case workInterval
        case shortBreak
        case longBreak
        case longBreakAfter
        case taskGoal
        
        case endDate
        case passedSteps
        case nowBreak
        
        case reminders
    }
    
    var workInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.workInterval.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.workInterval.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var shortBreak: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.shortBreak.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.shortBreak.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var longBreak: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.longBreak.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.longBreak.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var endDate: Date? {
        get {
            guard let date = UserDefaults.standard.value(forKey: settingKeys.endDate.rawValue) as? Date else { return nil }
            return date
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.endDate.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var passedSteps: Int? {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.passedSteps.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.passedSteps.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var nowBreak: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: settingKeys.nowBreak.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.nowBreak.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var longBreakAfter: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.longBreakAfter.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.longBreakAfter.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var taskGoal: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.taskGoal.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.taskGoal.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
    
    var reminders: Bool {
        get {
            return UserDefaults.standard.bool(forKey: settingKeys.reminders.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.reminders.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
}
