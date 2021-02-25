//
//  AssemblyModuleBuilder.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol AssemblyModuleBuilderProtocol {
    func createTimerViewController() -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createTimerViewController() -> UIViewController {
        let view = TimerViewController()
        let timerManager = TimerManager()
        let progressManager = ProgressManager()
        let presenter = TimerViewPresenter(view: view, timerManager: timerManager, progressManager: progressManager)
        view.presenter = presenter
        return view
    }
}
