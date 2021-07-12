//
//  Colors.swift
//  pomodoro
//
//  Created by vlsuv on 25.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum Colors {
    static let white = UIColor.white
    static let black = UIColor.black
    static let baseRed = UIColor(named: "baseRed") ?? UIColor()
    static let lightGray = UIColor(named: "lightGray") ?? UIColor()
    static let darkGray = UIColor(named: "darkGray") ?? UIColor()
    static let mediumGray = UIColor(named: "mediumGray") ?? UIColor()
    
    static let backgroundColor = UIColor(named: "backgroundColor") ?? Colors.white
    static let baseTextColor = UIColor(named: "baseTextColor") ?? Colors.black
    static let commentColor = UIColor(named: "commentColor") ?? Colors.mediumGray
    static let selectedColor = UIColor(named: "selectedColor") ?? Colors.baseRed
    static let buttonBackgroundColor = UIColor(named: "buttonBackgroundColor") ?? Colors.baseRed
    static let timeTextColor = UIColor(named: "timeTextColor") ?? Colors.mediumGray
    static let navigationButtonColor = UIColor(named: "navigationButtonColor") ?? Colors.baseRed
    static let stepButtonUnselectedColor = UIColor(named: "stepButtonUnselectedColor") ?? Colors.lightGray
    static let navigationTitleColor = UIColor(named: "navigationTitleColor") ?? Colors.black
    static let foregroundColor = UIColor(named: "foregroundColor") ?? UIColor()
}
