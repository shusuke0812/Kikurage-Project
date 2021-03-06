//
//  CalendarViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    /// BaseView
    private var baseView: CalendarBaseView { self.view as! CalendarBaseView } // sswiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: CalendarViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CalendarViewModel(kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension CalendarViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
    }
}
// MARK: - CalendarBaseView Delegate Method
extension CalendarViewController: CalendarBaseViewDelegate {
    func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
// MARK: - CalendarViewModel Delegate Method
extension CalendarViewController: CalendarViewModelDelegate {
    func didSuccessGetKikurageUser() {
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        print(errorMessage)
    }
}
