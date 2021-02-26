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
    init(view: TimePickerViewProtocol, router: RouterProtocol)
}

class TimePickerViewPresenter: TimePickerViewPresenterProtocol {
    weak var view: TimePickerViewProtocol!
    var router: RouterProtocol!
    
    required init(view: TimePickerViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
