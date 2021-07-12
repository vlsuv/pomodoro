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
        UITabBar.appearance().tintColor = Colors.selectedColor
        tabBar.isTranslucent = false
        tabBar.barTintColor = Colors.backgroundColor
        tabBar.unselectedItemTintColor = Colors.commentColor
    }
}
