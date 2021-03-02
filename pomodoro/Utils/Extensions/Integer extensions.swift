//
//  Integer extensions.swift
//  pomodoro
//
//  Created by vlsuv on 02.03.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

extension Int {
    func toString() -> String {
        let mins = self / 60
        let seconds = self % 60
        return "\(mins):\(seconds)"
    }
}
