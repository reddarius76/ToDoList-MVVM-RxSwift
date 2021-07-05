//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa

protocol TaskFormViewModelProtocol {
    init(
        task: Task?,
        router: TaskFormRouterProtocol,
        provider: TaskFormProviderProtocol
    )
    func transform(
        _ binding: TaskFormViewModel.UIBindings
    ) -> TaskFormViewModel.Output
}

struct TaskFormViewModel: TaskFormViewModelProtocol {
    private let task: Task?
    private let router: TaskFormRouterProtocol
    private let provider: TaskFormProviderProtocol
    typealias FormSubmitHandler = () -> Void
    var onSuccess: FormSubmitHandler?
    
    init(
        task: Task?,
        router: TaskFormRouterProtocol,
        provider: TaskFormProviderProtocol
    ) {
        self.task = task
        self.router = router
        self.provider = provider
    }
    
    struct UIBindings {
        let didTapSaveButton: Signal<Void>
        let nameValue: Driver<String>
        let descriptionValue: Driver<String>
        let deadlineValue: Driver<String>
        let priorityValue: Driver<String>
    }
    struct Output {
        let task: Driver<Task>
        let isEditing: Bool
        let disposables: Disposable
    }
    
    func transform(_ binding: UIBindings) -> Output {
        let isEmptyTask = task == nil
        
        let taskNewValue = Driver.combineLatest(
            binding.nameValue,
            binding.descriptionValue,
            binding.deadlineValue,
            binding.priorityValue
        ) { (name, description, deadline, priority) -> Task in
            .init(
                id: task?.id ?? UUID().uuidString,
                name: name,
                description: description,
                deadline: deadline,
                priority: priority
            )
        }
        
        let didTapSaveButton = binding.didTapSaveButton
            .withLatestFrom(taskNewValue)
            .flatMapLatest { task -> Signal<Void> in
                if isEmptyTask {
                    return provider.add(task: task)
                        .andThen(Signal.just(()))
                } else {
                    return provider.edit(task: task)
                        .andThen(Signal.just(()))
                }
            }
            .emit(onNext: {
                onSuccess?()
                router.popToRoot()
            })
            

    
        let disposables = Disposables.create([
            didTapSaveButton
        ])
        
        return .init(
            task: .just(task ?? .empty),
            isEditing: isEmptyTask,
            disposables: disposables
        )
    }
}
