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
        view.backgroundColor = Colors.backgroundColor
        
        configureNavigationController()
        configurePickerView()
        
        presenter.getSelectedParam()
    }
    
    // MARK: - Actions
    @objc private func handleSave() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        presenter.saveSetting(fromRow: selectedRow)
        NotificationCenter.default.post(name: .didUpdateTimerSettings, object: nil)
        dismiss(animated: true)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        navigationController?.navigationBar.tintColor = Colors.navigationButtonColor
        navigationController?.navigationBar.backgroundColor = Colors.backgroundColor
        navigationController?.navigationBar.isTranslucent = true
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
    func setParam(at index: Int) {
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
}

// MARK: - UIPickerViewDataSource
extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let options = presenter.setting.params
        return options.count
    }
}

// MARK: - UIPickerViewDelegate
extension TimePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let option = presenter.setting.params[row]

        return NSAttributedString(string: "\(option) \(presenter.setting.abbreviation)", attributes: [NSAttributedString.Key.foregroundColor: Colors.baseTextColor])
    }
}


