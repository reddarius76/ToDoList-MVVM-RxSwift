//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Oleg Krikun on 28.06.2021.
//

import UIKit

protocol TaskDetailRouterProtocol {
    init(_ taskDetailVC: UIViewController)
    typealias FormSubmitHandler = TaskFormViewModel.FormSubmitHandler
    func showAddTask(completion: FormSubmitHandler?)
    func showEditTask(model: Task, completion: FormSubmitHandler?)
}

struct TaskDetailRouter: TaskDetailRouterProtocol {
    
    private weak var taskDetailVC: UIViewController?
    
    init(_ taskDetailVC: UIViewController) {
        self.taskDetailVC = taskDetailVC
    }
    
    func showAddTask(completion: FormSubmitHandler?) {
        let taskVC = TaskFormViewController()
        var vm = TaskFormViewModel(
            task: nil,
            router: TaskFormRouter(taskVC),
            provider: TaskService.shared
        )
        vm.onSuccess = completion
        taskVC.bind(to: vm)
        self.taskDetailVC?.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func showEditTask(model: Task, completion: FormSubmitHandler?) {
        let taskVC = TaskFormViewController()
        var vm = TaskFormViewModel(
            task: model,
            router: TaskFormRouter(taskVC),
            provider: TaskService.shared
        )
        vm.onSuccess = completion
        taskVC.bind(to: vm)
        self.taskDetailVC?.navigationController?.pushViewController(taskVC, animated: true)
    }
}
