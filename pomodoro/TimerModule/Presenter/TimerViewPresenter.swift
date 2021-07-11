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
    init(view: TimerViewProtocol)
    func startTimer()
    func stopTimer()
}

class TimerViewPresenter: TimerViewPresenterProtocol {
    
    // MARK: - Properties
    let view: TimerViewProtocol
    
    var timerManager: TimerManagerProtocol?
    
    var notificationManager: NotificationManagerType?
    
    var remindersIsOn: Bool {
        return UserSettings.shared.reminders
    }
    
    // MARK: - Init
    required init(view: TimerViewProtocol) {
        self.view = view
        self.timerManager = TimerManager()
        self.notificationManager = NotificationManager()
        
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
    func didChangeEndDate(with date: Date?) {
        guard remindersIsOn else { return }
        
        guard let date = date else {
            notificationManager?.removeAllNotifications()
            return
        }
        
        notificationManager?.sendNotification(with: date)
    }
    
    func didChangeTimerState(to state: TimerState) {
        view.updateTimerState(state)
    }
    
    func secondsLeft(_ stringSeconds: String) {
        view.updateTimerLabel(with: stringSeconds)
    }
}
