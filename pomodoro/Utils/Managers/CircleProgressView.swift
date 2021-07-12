//
//  CircleProgressView.swift
//  pomodoro
//
//  Created by vlsuv on 08.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    // MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    enum AnimationKeys {
        static let progressAnimation = "progressAnimation"
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.traitCollection.performAsCurrent {
            self.progressLayer.strokeColor = Colors.selectedColor.cgColor
            self.circleLayer.strokeColor = Colors.stepButtonUnselectedColor.cgColor
        }
    }
    
    // MARK: - Configures
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0,
                                                           y: self.frame.size.height / 2.0),
                                        radius: 120,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 6.0
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(secondsLeft: TimeInterval, passedSeconds: TimeInterval) {
        guard progressLayer.timeOffset == 0.0 else {
            resume()
            return
        }
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.beginTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - passedSeconds
        circularProgressAnimation.duration = secondsLeft
        circularProgressAnimation.toValue = 1
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
