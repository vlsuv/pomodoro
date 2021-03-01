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
}
