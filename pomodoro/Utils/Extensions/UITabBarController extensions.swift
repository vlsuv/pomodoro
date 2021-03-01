//
//  UITabBarController extensions.swift
//  pomodoro
//
//  Created by vlsuv on 01.03.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UITabBarController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
