//
//  TimePickerViewPresenter.swift
//  pomodoro
//
//  Created by vlsuv on 26.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimePickerViewProtocol: class {
}

protocol TimePickerViewPresenterProtocol {
    init(view: TimePickerViewProtocol, router: RouterProtocol, setting: Setting)
    var setting: Setting! { get set }
    func saveSetting(fromRow row: Int)
}

class TimePickerViewPresenter: TimePickerViewPresenterProtocol {
    weak var view: TimePickerViewProtocol!
    var router: RouterProtocol!
    var setting: Setting!
    
    required init(view: TimePickerViewProtocol, router: RouterProtocol, setting: Setting) {
        self.view = view
        self.router = router
        self.setting = setting
    }
    
    func saveSetting(fromRow row: Int) {
        let selectedParam = setting.params[row]
        setting.completionHandler?(selectedParam)
    }
}
