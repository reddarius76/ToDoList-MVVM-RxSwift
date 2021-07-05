//
//  TaskDetailViewModel.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa

protocol TaskDetailViewModelProtocol {
    init(task: Task, router: TaskDetailRouterProtocol)
    func transform(
        _ binding: TaskDetailViewModel.Binding
    ) -> TaskDetailViewModel.Output
}

struct TaskDetailViewModel: TaskDetailViewModelProtocol {
    private let task: Task
    private let router: TaskDetailRouterProtocol
    typealias FormSubmitHandler = TaskFormViewModel.FormSubmitHandler
    var onSuccessfulEdit: FormSubmitHandler?
    init(task: Task, router: TaskDetailRouterProtocol) {
        self.task = task
        self.router = router
    }
    
    struct Binding {
        let didTapAddTask: Signal<Void>
        let didTapEditTask: Signal<Void>
    }
    struct Output {
        let nameTask: Driver<String>
        let descriptionTask: Driver<String>
        let deadlineTask: Driver<String>
        let priorityTask: Driver<String>
        let title: Driver<String>
        let disposables: Disposable
    }
    
    func transform(
        _ binding: Binding
    ) -> Output {
        
        let didTapAddTask = binding.didTapAddTask
            .emit(onNext: {
                router.showAddTask(completion: onSuccessfulEdit)
            })
        
        let didTapEditTask = binding.didTapEditTask
            .emit(onNext: {
                router.showEditTask(
                    model: self.task,
                    completion: onSuccessfulEdit
                )
            })
        
        let disposables = Disposables.create([
            didTapAddTask,
            didTapEditTask
        ])
        
        return .init(
            nameTask: .just(task.name),
            descriptionTask: .just(task.description),
            deadlineTask: .just(task.deadline),
            priorityTask: .just(task.priority),
            title: .just(task.name),
            disposables: disposables
        )
    }
}
