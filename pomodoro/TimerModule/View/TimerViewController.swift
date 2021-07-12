//
//  ViewController.swift
//  pomodoro
//
//  Created by vlsuv on 24.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    // MARK: - Properties
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 46, weight: .medium)
        label.textColor = Colors.timeTextColor
        return label
    }()
    
    var timerTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.timeTextColor
        label.textAlignment = .center
        return label
    }()
    
    var circleProgressView: CircleProgressView = {
        let progressView = CircleProgressView()
        return progressView
    }()
    
    var intervalButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    var intervalButtons: [UIButton] = [UIButton]()
    
    let startButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Start", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.foregroundColor
        ])
        let selectAttributedString = NSAttributedString(string: "Pause", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.foregroundColor
        ])
        button.backgroundColor = Colors.buttonBackgroundColor
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(selectAttributedString, for: .selected)
        button.addTarget(self, action: #selector(handleStartTimer), for: .touchUpInside)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Stop", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.foregroundColor
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.backgroundColor = Colors.buttonBackgroundColor
        button.addTarget(self, action: #selector(handleStopTimer), for: .touchUpInside)
        return button
    }()
    
    var presenter: TimerViewPresenterProtocol?
    
    var taskGoal: Int {
        return UserSettings.shared.taskGoal
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        
        configureNavigationController()
        setupTimeLabel()
        setupTimeButtons()
        configureProgressView()
        configureStepsButtons()
        configureTimerTypeLabel()
    }
    
    // MARK: - Targets
    @objc private func handleStartTimer() {
        presenter?.startTimer()
    }
    
    @objc private func handleStopTimer() {
        presenter?.stopTimer()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationTitleColor]
    }
    
    private func setupTimeLabel() {
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTimeButtons() {
        let stackView = UIStackView(arrangedSubviews: [stopButton, startButton])
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         paddingLeft: 30,
                         paddingRight: 30,
                         paddingBottom: 40,
                         height: 50)
        
        startButton.layer.cornerRadius = 6
        stopButton.layer.cornerRadius = 6
        stopButton.isHidden = true
    }
    
    private func configureProgressView() {
        view.addSubview(circleProgressView)
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        circleProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circleProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configureStepsButtons() {
        for _ in 0..<taskGoal {
            let button = UIButton()
            let buttonSize: CGFloat = 20
            button.anchor(height: buttonSize, width: buttonSize)
            button.layer.cornerRadius = buttonSize / 2
            button.backgroundColor = Colors.stepButtonUnselectedColor
            
            intervalButtons.append(button)
            intervalButtonsStackView.addArrangedSubview(button)
        }
        
        view.addSubview(intervalButtonsStackView)
        intervalButtonsStackView.anchor(bottom: startButton.topAnchor, paddingBottom: 40)
        intervalButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configureTimerTypeLabel() {
        view.addSubview(timerTypeLabel)
        timerTypeLabel.anchor(top: timeLabel.bottomAnchor, paddingTop: 8)
        timerTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: - TimerViewProtocol
extension TimerViewController: TimerViewProtocol {
    func updateTimerState(_ state: TimerState) {
        
        switch state {
        case .start(secondsLeft: let secondsLeft, passedSeconds: let passedSeconds, timerType: let timerType):
            timerTypeLabel.text = timerType.title
            circleProgressView.progressAnimation(secondsLeft: secondsLeft, passedSeconds: passedSeconds)
            changeButtonStatus(isOn: true)
        case .pause:
            circleProgressView.pause()
            changeButtonStatus(isOn: false)
        case .stop(passedSteps: let passedSteps, nextTimerType: let timerType):
            circleProgressView.removeAnimation()
            updateStepsButtons(with: passedSteps)
            timerTypeLabel.text = timerType.title
            changeButtonStatus(isOn: false)
        }
    }
    
    func updateTimerLabel(with time: String) {
        timeLabel.text = time
    }
}

// MARK: - Helpers
extension TimerViewController {
    private func changeButtonStatus(isOn: Bool) {
        self.stopButton.isHidden = !isOn
        self.startButton.isSelected = isOn
    }
    
    private func updateStepsButtons(with steps: Int) {
        for (index, button) in intervalButtons.enumerated() {
            if index < steps {
                button.backgroundColor = Colors.selectedColor
            } else {
                button.backgroundColor = Colors.stepButtonUnselectedColor
            }
        }
    }
}
