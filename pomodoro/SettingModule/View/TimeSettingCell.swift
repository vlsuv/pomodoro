//
//  TimeSettingCell.swift
//  pomodoro
//
//  Created by vlsuv on 08.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimeSettingCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "TimeSettingCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private var selectedParamLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Colors.mediumGray
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    func configure(_ setting: TimeSettingOption) {
        titleLabel.text = setting.title
        
        guard let selectedParam = setting.selectedParam?() else { return }
        
        selectedParamLabel.text = "\(selectedParam) \(setting.abbreviation)"
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [titleLabel, selectedParamLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        selectedParamLabel.anchor(top: contentView.topAnchor,
                                  right: contentView.rightAnchor,
                                  bottom: contentView.bottomAnchor,
                                  paddingRight: 18)
        
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: selectedParamLabel.leftAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 18,
                          paddingRight: 8)
    }
}
