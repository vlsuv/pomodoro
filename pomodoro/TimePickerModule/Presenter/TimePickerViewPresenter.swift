//
//  TimePickerViewPresenter.swift
//  pomodoro
//
//  Created by vlsuv on 26.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimePickerViewProtocol: class {
    func setParam(at index: Int)
}

protocol TimePickerViewPresenterProtocol {
    init(view: TimePickerViewProtocol, router: RouterProtocol, setting: Setting)
    var setting: Setting { get set }
    func saveSetting(fromRow row: Int)
    func getSelectedParam()
}

class TimePickerViewPresenter: TimePickerViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: TimePickerViewProtocol!
    
    var router: RouterProtocol
    
    var setting: Setting
    
    // MARK: - Init
    required init(view: TimePickerViewProtocol, router: RouterProtocol, setting: Setting) {
        self.view = view
        self.router = router
        self.setting = setting
    }
    
    // MARK: - Handlers
    func saveSetting(fromRow row: Int) {
        let selectedParam = setting.params[row]
        setting.completionHandler?(selectedParam)
    }
    
    func getSelectedParam() {
        guard let selectedParam = setting.selectedParam?(), let index = setting.params.firstIndex(of: selectedParam) else {
            return
        }
        
        view.setParam(at: index)
    }
}
