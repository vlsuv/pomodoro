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
        label.textColor = Colors.darkGray
        label.text = "25:00"
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Start", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.white
        ])
        let selectAttributedString = NSAttributedString(string: "Pause", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.white
        ])
        button.backgroundColor = Colors.baseRed
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(selectAttributedString, for: .selected)
        button.addTarget(self, action: #selector(handleStartTimer), for: .touchUpInside)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Stop", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: Colors.white
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.backgroundColor = Colors.baseRed
        button.addTarget(self, action: #selector(handleStopTimer), for: .touchUpInside)
        return button
    }()
    
    var circleProgressView: CircleProgressView = {
        let progressView = CircleProgressView()
        return progressView
    }()
    
    var presenter: TimerViewPresenterProtocol!

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        setupTimeLabel()
        setupTimeButtons()
        configureProgressView()
    }
    
    // MARK: - Targets
    @objc private func handleStartTimer() {
        presenter.startTimer()
    }
    
    @objc private func handleStopTimer() {
        presenter.stopTimer()
    }
    
    // MARK: - Configures
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
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 30, paddingRight: 30, paddingBottom: 40, height: 50)
        
        startButton.layer.cornerRadius = 6
        stopButton.layer.cornerRadius = 6
        stopButton.isHidden = true
    }
    
    private func configureProgressView() {
        view.addSubview(circleProgressView)
        circleProgressView.center = view.center
    }
}

// MARK: - TimerViewProtocol
extension TimerViewController: TimerViewProtocol {
    func updateTimerState(_ state: TimerState) {
        switch state {
        case .start(time: let time):
            circleProgressView.progressAnimation(duration: time)
            changeButtonStatus(isOn: true)
        case .resume:
            circleProgressView.resume()
            changeButtonStatus(isOn: true)
        case .pause:
            circleProgressView.pause()
            changeButtonStatus(isOn: false)
        case .stop:
            circleProgressView.removeAnimation()
            changeButtonStatus(isOn: false)
        }
    }
    
    func updateTimerLabel(with time: String) {
        timeLabel.text = time
    }
}

extension TimerViewController {
    private func changeButtonStatus(isOn: Bool) {
        self.stopButton.isHidden = !isOn
        self.startButton.isSelected = isOn
    }
}
