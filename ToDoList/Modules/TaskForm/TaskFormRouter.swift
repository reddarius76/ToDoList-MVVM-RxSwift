//
//  TaskRouter.swift
//  ToDoList
//
//  Created by Oleg Krikun on 28.06.2021.
//

import UIKit

protocol TaskFormRouterProtocol {
    init(_ taskVC: UIViewController)
    func popToRoot()
}

struct TaskFormRouter: TaskFormRouterProtocol {
    
    private weak var taskVC: UIViewController?
    
    init(_ taskVC: UIViewController) {
        self.taskVC = taskVC
    }
    
    func popToRoot() {
        self.taskVC?.navigationController?.popToRootViewController(animated: true)
    }
}

