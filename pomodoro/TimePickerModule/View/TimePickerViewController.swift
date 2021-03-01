//
//  PickerViewController.swift
//  pomodoro
//
//  Created by vlsuv on 26.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {
    
    // MARK: - Properties
    var pickerView: UIPickerView!
    var presenter: TimePickerViewPresenterProtocol!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        configureNavigationController()
        configurePickerView()
    }
    
    // MARK: - Actions
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = saveButton
        navigationItem.rightBarButtonItem = cancelButton
        
        navigationController?.navigationBar.tintColor = Colors.baseRed
    }
    
    private func configurePickerView() {
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        view.addSubview(pickerView)
        pickerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
}

// MARK: - TimePickerViewProtocol
extension TimePickerViewController: TimePickerViewProtocol {
    
}

// MARK: - UIPickerViewDataSource
extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
}

// MARK: - UIPickerViewDelegate
extension TimePickerViewController: UIPickerViewDelegate {
    
}


