//
//  ListTaskRouter.swift
//  ToDoList
//
//  Created by Oleg Krikun on 25.06.2021.
//

import UIKit

protocol ListTasksRouterProtocol {
    init(_ listTasksVC: UIViewController)
    func showDetail(model: Task, onSuccess: FormSubmitHandler?)
    typealias FormSubmitHandler = TaskFormViewModel.FormSubmitHandler
    func showAddTask(onSuccess: FormSubmitHandler?)
}

struct ListTasksRouter: ListTasksRouterProtocol {
    
    private weak var listTasksVC: UIViewController?
    
    init(_ listTasksVC: UIViewController) {
        self.listTasksVC = listTasksVC
    }
    
    func showDetail(model: Task, onSuccess: FormSubmitHandler?) {
        let taskDetailVC = TaskDetailViewController()
        var viewModel = TaskDetailViewModel(
            task: model,
            router: TaskDetailRouter(taskDetailVC)
        )
        viewModel.onSuccessfulEdit = onSuccess
        taskDetailVC.bind(to: viewModel)
        self.listTasksVC?.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func showAddTask(onSuccess: FormSubmitHandler?) {
        let taskVC = TaskFormViewController()
        var viewModel = TaskFormViewModel(
            task: nil,
            router: TaskFormRouter(taskVC),
            provider: TaskService.shared
        )
        viewModel.onSuccess = onSuccess
        taskVC.bind(to: viewModel)
        self.listTasksVC?.navigationController?.pushViewController(taskVC, animated: true)
    }
}
