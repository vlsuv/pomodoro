//
//  SettingSection.swift
//  pomodoro
//
//  Created by vlsuv on 10.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

struct SettingSection {
    let title: String
    let option: [SettingOptionType]
}

enum SettingOptionType {
    case staticCell(model: StaticSettingOption)
    case switchCell(model: SwitchSettingOption)
}

struct StaticSettingOption {
    var name: String
    var params: [Int]
    var abbreviation: String
    var selectedParam: (() -> (Int))?
    var completionHandler: ((Int) -> ())?
}

struct SwitchSettingOption {
    var name: String
    var handler: (() -> ())?
    var isOn: Bool
}
