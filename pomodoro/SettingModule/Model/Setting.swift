//
//  Setting.swift
//  pomodoro
//
//  Created by vlsuv on 26.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

struct Setting {
    var name: String
    var params: [Int]
    var selectedParam: (() -> (Int))?
    var completionHandler: ((Int) -> ())?
}
