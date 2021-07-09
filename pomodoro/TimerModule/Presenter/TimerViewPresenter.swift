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
    func updateTimerType(_ type: BreakType)
    func updatePassedSteps(_ step: Int)
}

protocol TimerViewPresenterProtocol {
    init(view: TimerViewProtocol)
    func startTimer()
    func stopTimer()
}

class TimerViewPresenter: TimerViewPresenterProtocol {
    
    // MARK: - Properties
    let view: TimerViewProtocol
    
    var timerManager: TimerManagerProtocol?
    
    required init(view: TimerViewProtocol) {
        self.view = view
        self.timerManager = TimerManager()
        
        timerManager?.delegate = self
        
        if let time = timerManager?.secondsLeftText() {
            view.updateTimerLabel(with: time)
        }
    }
    
    // MARK: - Timer Handlers
    func startTimer() {
        timerManager?.startTimer()
    }
    
    func stopTimer() {
        timerManager?.stopTimer()
    }
}

// MARK: - TimerManagerDelegate
extension TimerViewPresenter: TimerManagerDelegate {
    func didChangeTimerType(_ type: BreakType) {
        view.updateTimerType(type)
    }
    
    func didChangePassedSteps(_ step: Int) {
        view.updatePassedSteps(step)
    }
    
    func didChangeTimerState(_ state: TimerState) {
        view.updateTimerState(state)
    }
    
    func didChangeTime(_ timeString: String) {
        view.updateTimerLabel(with: timeString)
    }
}
