//
//  UIViewController+Extension.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import UIKit

extension UIViewController {
    func removeTitleFromBackButton() {
        let backButton = UIBarButtonItem(
            title: Constants.emptyText,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
