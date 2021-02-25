//
//  CircularProgressView.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol ProgressManagerProtocol: class {
    var progressView: UIView { get set }
    func progressAnimation(duration: TimeInterval)
    func pause()
    func resume()
    func removeAnimation()
}

class ProgressManager: ProgressManagerProtocol {
    var progressView: UIView = UIView()
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    enum AnimationKeys {
        static let progressAnimation = "progressAnimation"
    }
    
    init() {
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: progressView.frame.size.width / 2.0, y: progressView.frame.size.height / 2.0), radius: 120, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 6.0
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.blue.cgColor
        
        progressView.layer.addSublayer(circleLayer)
        progressView.layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        guard progressLayer.timeOffset == 0.0 else {
            resume()
            return
        }
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: AnimationKeys.progressAnimation)
    }
    
    func pause() {
        let pausedTime: CFTimeInterval = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resume() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }
    
    func removeAnimation() {
        progressLayer.removeAnimation(forKey: AnimationKeys.progressAnimation)
    }
}
