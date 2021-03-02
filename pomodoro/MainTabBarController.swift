//
//  MainTabBarController.swift
//  pomodoro
//
//  Created by vlsuv on 02.03.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = Colors.baseRed
    }
}
