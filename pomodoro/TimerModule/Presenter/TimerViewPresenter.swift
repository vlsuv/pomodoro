//
//  TimerModulePresenter.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import Foundation

protocol TimerViewProtocol {
    func update(time: String)
    func changeButtonStatus(isOn: Bool)
    func setupProgressView(_ progressView: UIView)
}

protocol TimerViewPresenterProtocol {
    init(view: TimerViewProtocol, timerManager: TimerManagerProtocol, progressManager: ProgressManagerProtocol)
    func startTimer()
    func stopTimer()
}

class TimerViewPresenter: TimerViewPresenterProtocol {
    var view: TimerViewProtocol!
    var timerManager: TimerManagerProtocol!
    var progressManager: ProgressManagerProtocol!
    
    required init(view: TimerViewProtocol, timerManager: TimerManagerProtocol, progressManager: ProgressManagerProtocol) {
        self.view = view
        self.timerManager = timerManager
        self.progressManager = progressManager
        
        configureTimerManager()
        configureCircularProgressView()
    }
    
    func configureTimerManager() {
        timerManager.timerCompletionHandler = { [weak self] time in
            guard let self = self else { return }
            let time = Int(time)
            self.view.update(time: time.toString())
        }
    }
    
    func configureCircularProgressView() {
        view.setupProgressView(progressManager.progressView)
    }
    
    func startTimer() {
        timerManager.startTimer()
        view.changeButtonStatus(isOn: timerManager.active)
    }
    
    func stopTimer() {
        timerManager.stopTimer()
        view.changeButtonStatus(isOn: false)
    }
}
