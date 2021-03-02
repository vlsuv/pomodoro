//
//  TimerManager.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimerManagerProtocol: class {
    var timerCompletionHandler: ((Double) -> ())? { get set }
    var active: Bool { get }
    var deactive: Bool { get }
    func startTimer()
    func pauseTimer()
    func stopTimer()
}

class TimerManager: TimerManagerProtocol {
    private var timer: Timer?
    private var endDate: Date?
    private var secondsLeft: TimeInterval!
    var timerCompletionHandler: ((Double) -> ())?
    
    lazy var workInterval: Double = {
        return Double(UserSettings.shared.workInterval)
    }()
    lazy var breakInterval: Double = {
        return Double(UserSettings.shared.breakInterval)
    }()
    
    var breakStatus: Bool = false
    let progressManager: ProgressManagerProtocol
    
    init(progressManager: ProgressManagerProtocol) {
        self.progressManager = progressManager
        self.secondsLeft = workInterval
    }
    
    var active: Bool {
        return timer != nil && endDate != nil
    }
    
    var deactive: Bool {
        return timer == nil || (timer != nil && endDate == nil)
    }
    
    @objc func timerTick() {
        secondsLeft -= 1
        
        if secondsLeft == 0 {
            breakStatus = true
            stopTimer()
        }
        
        timerCompletionHandler?(secondsLeft)
    }
    
    func startTimer() {
        if deactive {
            progressManager.progressAnimation(duration: workInterval)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            endDate = Date().addingTimeInterval(secondsLeft)
        } else if active {
            pauseTimer()
        }
    }
    
    func pauseTimer() {
        progressManager.pause()
        
        timer?.invalidate()
        endDate = nil
    }
    
    func stopTimer() {
        progressManager.removeAnimation()
        
        timer?.invalidate()
        timer = nil
        endDate = nil
        
        if breakStatus {
            secondsLeft = breakInterval
            breakStatus = false
        } else {
            secondsLeft = workInterval
        }
        
        
        timerCompletionHandler?(Double(secondsLeft))
    }
    
    func saveDate() {
        timer?.invalidate()
        
        let defaults = UserDefaults.standard
        defaults.set(endDate, forKey: "EndDate")
    }
    
    func loadDate() {
        let defaults = UserDefaults.standard
        
        if let date = defaults.value(forKey: "EndDate") as? Date {
            if Date() > date {
                // Timer is expired
            } else {
                secondsLeft = date.timeIntervalSince(Date())
                
                startTimer()
            }
        }
    }
}
