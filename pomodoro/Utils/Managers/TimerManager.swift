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

protocol TimerManagerDelegate {
    func didChangeTimerState(_ state: TimerState)
    func didChangeTime(_ timeString: String)
}

protocol TimerManagerProtocol: class {
    var delegate: TimerManagerDelegate? { get set }
    
    func startTimer()
    func pauseTimer()
    func stopTimer()
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
    
    var state: TimerState = .stop {
        didSet {
            delegate?.didChangeTimerState(state)
        }
    }
    
    // MARK: - UserDefaults Properties
    lazy var workInterval: Double = {
        return Double(UserSettings.shared.workInterval)
    }()
    
    lazy var breakInterval: Double = {
        return Double(UserSettings.shared.breakInterval)
    }()
    
    var longBreakInterval: Double?
    
    // MARK: - Init
    init() {
        secondsLeft = workInterval
        
        configureNotificationCenterObserve()
    }
    
    // MARK: - Status
    private var firstActive: Bool {
        return timer == nil && endDate == nil
    }
    
    private var active: Bool {
        return timer != nil && endDate != nil
    }
    
    private var deactive: Bool {
        return timer == nil || (timer != nil && endDate == nil)
    }
    
    // MARK: - Manage
    @objc func timerTick() {
        secondsLeft -= 1
        
        if secondsLeft == 0 {
            stopTimer()
        }
    }
    
    func startTimer() {
        if deactive {
            if firstActive {
                state = .start(time: secondsLeft)
            } else {
                state = .resume
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            endDate = Date().addingTimeInterval(secondsLeft)
        } else if active {
            pauseTimer()
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        endDate = nil
        state = .pause
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        endDate = nil
        secondsLeft = workInterval
        state = .stop
    }
}

// MARK: - Resign App Handlers
extension TimerManager {
    private func configureNotificationCenterObserve() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.loadDate()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveDate()
        }
    }
    
    private func saveDate() {
        if active {
            UserSettings.shared.endDate = endDate
            
            stopTimer()
        }
    }
    
    private func loadDate() {
        if let date = UserSettings.shared.endDate {
            if Date() > date {
                
            } else {
                secondsLeft = date.timeIntervalSince(Date())
                
                UserSettings.shared.endDate = nil
                
                startTimer()
            }
        }
    }
}

// MARK: - Date Helpers
extension TimerManager {
    func intervalToString(ti: NSInteger) -> String {
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}
