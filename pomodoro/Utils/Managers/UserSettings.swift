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
        case breakInterval
        case longBreakInterval
        case endDate
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
    
    var breakInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.breakInterval.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.breakInterval.rawValue
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
    
    var longBreakInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: settingKeys.longBreakInterval.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = settingKeys.longBreakInterval.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
}
