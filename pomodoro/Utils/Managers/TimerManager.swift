//
//  TimerManager.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimerManagerDelegate {
    func secondsLeft(_ stringSeconds: String)
    func didChangeTimerState(to state: TimerState)
    func didChangeEndDate(with date: Date?)
}

enum TimerState {
    case start(secondsLeft: Double, passedSeconds: Double, timerType: TimerType)
    case pause
    case stop(passedSteps: Int, nextTimerType: TimerType)
}

enum TimerType {
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
    private var endDateSetted: Bool = false
    
    private var secondsLeft: TimeInterval! {
        willSet(newValue) {
            let time = intervalToString(ti: NSInteger(newValue))
            
            delegate?.secondsLeft(time)
        }
    }
    
    private var timerState: TimerState {
        willSet {
            delegate?.didChangeTimerState(to: newValue)
        }
    }
    
    // MARK: - Steps Properties
    private var maxSteps: Int
    
    private var passedSteps: Int
    
    private var nowBreak: Bool
    
    private var timerType: TimerType {
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
    
    // MARK: - Settings Properties
    private var workInterval: Double {
        return Double(UserSettings.shared.workInterval) * 60
    }

    private var breakInterval: Double {
        return Double(UserSettings.shared.shortBreak) * 60
    }

    private var longBreakInterval: Double {
        return Double(UserSettings.shared.longBreak) * 60
    }
    
    // MARK: - Timer State Properties
    private var active: Bool {
        return timer != nil && endDate != nil
    }
    
    private var deactive: Bool {
        return timer == nil || (timer != nil && endDate == nil)
    }
    
    // MARK: - Init
    init() {
        self.maxSteps = 4
        self.passedSteps = 0
        self.nowBreak = false
        
        self.timerState = .stop(passedSteps: passedSteps, nextTimerType: .work)
        
        self.secondsLeft = workInterval
        
        configureNotificationCenterObserve()
    }
    
    // MARK: - Inputs Timer Manage
    func startTimer() {
        guard deactive else {
            pauseTimer()
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        
        endDate = Date().addingTimeInterval(secondsLeft)
        
        timerState = .start(secondsLeft: secondsLeft, passedSeconds: workInterval - secondsLeft, timerType: timerType)
        
        if !endDateSetted {
            endDateSetted = true
            
            delegate?.didChangeEndDate(with: endDate!)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        secondsLeft = workInterval
        
        endDate = nil
        passedSteps = 0
        nowBreak = false
        
        timerState = .stop(passedSteps: passedSteps, nextTimerType: timerType)
        
        delegate?.didChangeEndDate(with: nil)
        endDateSetted = false
    }
    
    // MARK: - Private Timer Manage
    @objc private func timerTick() {
        secondsLeft -= 1
        
        if secondsLeft <= 0 {
            if timerType == .work {
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
        
        delegate?.didChangeEndDate(with: nil)
        endDateSetted = false
    }
    
    private func nextTimer() {
        timer?.invalidate()
        timer = nil
        
        endDate = nil
        
        switch timerType {
        case .work:
            secondsLeft = workInterval
        case .shortBreak:
            secondsLeft = breakInterval
        case .longBreak:
            secondsLeft = longBreakInterval
        }
        
        timerState = .stop(passedSteps: passedSteps, nextTimerType: timerType)
        
        endDateSetted = false
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
        UserSettings.shared.passedSteps = self.passedSteps
        UserSettings.shared.nowBreak = self.nowBreak
        
        timer?.invalidate()
        timer = nil
        endDate = nil
    }
    
    private func loadTimerData() {
        guard let endDate = UserSettings.shared.endDate, let passedSteps = UserSettings.shared.passedSteps, let nowBreak = UserSettings.shared.nowBreak else {
            return
        }
        
        if Date() > endDate {
            nextTimer()
        } else {
            self.secondsLeft = endDate.timeIntervalSince(Date())
            self.passedSteps = passedSteps
            self.nowBreak = nowBreak
            
            startTimer()
        }
        
        UserSettings.shared.endDate = nil
        UserSettings.shared.passedSteps = nil
        UserSettings.shared.nowBreak = nil
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
