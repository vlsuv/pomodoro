//
//  SettingViewController.swift
//  pomodoro
//
//  Created by vlsuv on 25.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = Colors.white
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var presenter: SettingViewPresenterProtocol?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        configureTableView()
    }
    
    // MARK: - Configures
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TimeSettingCell.self, forCellReuseIdentifier: TimeSettingCell.identifier)
        tableView.register(SwitchSettingCell.self, forCellReuseIdentifier: SwitchSettingCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
}

// MARK: - SettingViewProtocol
extension SettingViewController: SettingViewProtocol {
    func update() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.settings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.settings[section].option.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let setting = presenter?.settings[indexPath.section].option[indexPath.row] else {
            return UITableViewCell()
        }
        
        switch setting {
        case .staticCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeSettingCell.identifier, for: indexPath) as? TimeSettingCell else { return UITableViewCell() }
            cell.configure(model)
            
            return cell
        case .switchCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingCell.identifier, for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
            cell.didChangedSwitch = { [weak self] _ in
                guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                
                self?.presenter?.showTimePicker(indexPath: indexPath)
            }
            cell.configure(model)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.showTimePicker(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
