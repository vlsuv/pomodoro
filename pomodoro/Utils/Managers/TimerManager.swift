//
//  TimerManager.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum TimerState {
    case start(time: Double)
    case resume
    case pause
    case stop
}

enum BreakType {
    case work
    case shortBreak
    case longBreak
    
    var title: String {
        switch self {
        case .work:
            return "Work"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}

protocol TimerManagerDelegate {
    func didChangeTimerState(_ state: TimerState)
    func didChangeTime(_ timeString: String)
    func didChangeTimerType(_ type: BreakType)
    func didChangePassedSteps(_ step: Int)
}

protocol TimerManagerProtocol: class {
    var delegate: TimerManagerDelegate? { get set }
    
    func startTimer()
    func stopTimer()
    
    func secondsLeftText() -> String
}

class TimerManager: TimerManagerProtocol {
    
    // MARK: - Properties
    var delegate: TimerManagerDelegate?
    
    private var timer: Timer?
    
    private var endDate: Date?
    
    private var secondsLeft: TimeInterval! {
        willSet(newValue) {
            let time = intervalToString(ti: NSInteger(newValue))
            
            delegate?.didChangeTime(time)
        }
    }
    
    private var timerState: TimerState = .stop
    
    // MARK: - UserDefaults Properties
    private var workInterval: Double {
        return Double(UserSettings.shared.workInterval) * 60
    }
    
    private var breakInterval: Double {
        return Double(UserSettings.shared.breakInterval) * 60
    }
    
    private var longBreakInterval: Double {
        return Double(UserSettings.shared.longBreakInterval) * 60
    }
    
    // MARK: - Steps Properties
    private var maxSteps: Int = 4
    
    private var passedSteps: Int = 0
    
    private var nowBreak: Bool = false
    
    private var breakType: BreakType {
        if nowBreak {
            if passedSteps == maxSteps {
                return .longBreak
            } else {
                return .shortBreak
            }
        } else {
            return .work
        }
    }
    
    // MARK: - Active Properties
    private var firstActive: Bool {
        return timer == nil && endDate == nil
    }
    
    private var active: Bool {
        return timer != nil && endDate != nil
    }
    
    private var deactive: Bool {
        return timer == nil || (timer != nil && endDate == nil)
    }
    
    // MARK: - Init
    init() {
        secondsLeft = workInterval
        
        configureNotificationCenterObserve()
    }
    
    // MARK: - Inputs Timer Manage
    func startTimer() {
        guard deactive else {
            pauseTimer()
            return
        }
        
        if firstActive {
            timerState = .start(time: secondsLeft)
        } else {
            timerState = .resume
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        endDate = Date().addingTimeInterval(secondsLeft)
        
        sendToDelegate()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        secondsLeft = workInterval
        
        endDate = nil
        passedSteps = 0
        nowBreak = false
        
        timerState = .stop
        
        sendToDelegate()
    }
    
    // MARK: - Private Timer Manage
    @objc private func timerTick() {
        secondsLeft -= 1
        
        if secondsLeft <= 0 {
            if breakType == .work {
                passedSteps += 1
            }
            
            nowBreak.toggle()
            
            nextTimer()
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        endDate = nil
        timerState = .pause
        
        sendToDelegate()
    }
    
    private func nextTimer() {
        timer?.invalidate()
        timer = nil
        
        endDate = nil
        
        switch breakType {
        case .work:
            secondsLeft = workInterval
        case .shortBreak:
            secondsLeft = breakInterval
        case .longBreak:
            secondsLeft = longBreakInterval
        }
        
        timerState = .stop
        
        sendToDelegate()
    }
    
    private func sendToDelegate() {
        delegate?.didChangeTimerState(timerState)
        delegate?.didChangeTimerType(breakType)
        delegate?.didChangePassedSteps(passedSteps)
    }
}

// MARK: - Timer Observers
extension TimerManager {
    private func configureNotificationCenterObserve() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.loadTimerData()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveTimerData()
        }
    }
    
    private func saveTimerData() {
        guard active else { return }
        
        UserSettings.shared.endDate = self.endDate
        UserSettings.shared.pomodoroStep = self.passedSteps
        UserSettings.shared.needBreak = self.nowBreak
        
        stopTimer()
    }
    
    private func loadTimerData() {
        guard let endDate = UserSettings.shared.endDate, let passedSteps = UserSettings.shared.pomodoroStep, let nowBreak = UserSettings.shared.needBreak else {
            return
        }
        
        if Date() > endDate {
            
        } else {
            self.secondsLeft = endDate.timeIntervalSince(Date())
            self.passedSteps = passedSteps
            self.nowBreak = nowBreak
            
            startTimer()
        }
        
        UserSettings.shared.endDate = nil
        UserSettings.shared.pomodoroStep = nil
        UserSettings.shared.needBreak = nil
    }
}

// MARK: - Helpers
extension TimerManager {
    func secondsLeftText() -> String {
        let time = intervalToString(ti: Int(secondsLeft))
        return time
    }
    
    private func intervalToString(ti: NSInteger) -> String {
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}
