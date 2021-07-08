//
//  TimerModulePresenter.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimerViewProtocol {
    func updateTimerLabel(with time: String)
    func updateTimerState(_ state: TimerState)
}

protocol TimerViewPresenterProtocol {
    init(view: TimerViewProtocol, timerManager: TimerManagerProtocol)
    func startTimer()
    func stopTimer()
}

class TimerViewPresenter: TimerViewPresenterProtocol {
    
    // MARK: - Properties
    let view: TimerViewProtocol
    
    let timerManager: TimerManagerProtocol
    
    required init(view: TimerViewProtocol, timerManager: TimerManagerProtocol) {
        self.view = view
        self.timerManager = timerManager
        
        timerManager.delegate = self
    }
    
    // MARK: - Timer Handlers
    func startTimer() {
        timerManager.startTimer()
    }
    
    func stopTimer() {
        timerManager.stopTimer()
    }
}

// MARK: - TimerManagerDelegate
extension TimerViewPresenter: TimerManagerDelegate {
    func didChangeTimerState(_ state: TimerState) {
        view.updateTimerState(state)
    }
    
    func didChangeTime(_ timeString: String) {
        view.updateTimerLabel(with: timeString)
    }
}
