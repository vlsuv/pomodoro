//
//  SwitchSettingCell.swift
//  pomodoro
//
//  Created by vlsuv on 11.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class SwitchSettingCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "SwitchSettingCell"
    
    var didChangedSwitch: ((Bool) -> ())?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.baseTextColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.tintColor = Colors.stepButtonUnselectedColor
        switchView.onTintColor = Colors.selectedColor
        return switchView
    }()
    
    func configure(_ model: SwitchSettingOption) {
        titleLabel.text = model.title
        
        if let isOn = model.isOn?() {
            switchView.isOn = isOn
        }
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged(_ sender: UISwitch) {
        didChangedSwitch?(sender.isOn)
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.backgroundColor
        backgroundColor = Colors.backgroundColor
        
        accessoryView?.tintColor = Colors.black
        accessoryView?.backgroundColor = Colors.black
        
        addSubviews()
        configureConstraints()
        
        switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel]
            .forEach { contentView.addSubview($0) }
        
        accessoryView = switchView
    }
    
    private func configureConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 18,
                          paddingRight: 8)
    }
}
