//
//  ListTasksViewModel.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa

protocol ListTasksViewModelProtocol {
    init(
        router: ListTasksRouterProtocol,
        provider: ListTasksProviderProtocol
    )
    typealias UIBindings = ListTasksViewModel.UIBindings
    func transform(_ binding: UIBindings) -> ListTasksViewModel.Output
}

struct ListTasksViewModel: ListTasksViewModelProtocol {
    private let needsReloadingRelay = PublishRelay<Void>()
    private let router: ListTasksRouterProtocol
    private let provider: ListTasksProviderProtocol
    
    struct UIBindings {
        let modelSelected: ControlEvent<Task>
        let swipeDeleted: ControlEvent<IndexPath>
        let didTapAddTask: Signal<Void>
    }
    struct Output {
        let tasks: Driver<[Task]>
        let disposables: Disposable
    }
    
    init(
        router: ListTasksRouterProtocol,
        provider: ListTasksProviderProtocol
    ) {
        self.router = router
        self.provider = provider
    }
    
    func transform(_ binding: UIBindings) -> Output {

        let tasks = needsReloadingRelay
            .asSignal()
            .startWith(())
            .flatMapLatest {
                provider.getTasks()
                    .asDriver(onErrorJustReturn: [])
            }
        
        let modelSelected = binding.modelSelected
            .bind {
                router.showDetail(model: $0) {
                    needsReloadingRelay.accept(())
                }
            }
        
        let swipeDeleted = binding.swipeDeleted
            .withLatestFrom(tasks) { indexPath, tasks in
                tasks[indexPath.row].id
            }
            .flatMapLatest { id -> Signal<Void> in
                provider.delete(taskBy: id)
                    .andThen(Signal.just(()))
            }
            .bind { id in
                needsReloadingRelay.accept(())
            }
        
        let didTapAddTask = binding.didTapAddTask
            .emit(onNext: {
                router.showAddTask { needsReloadingRelay.accept(()) }
            })
        
        let disposables = Disposables.create([
            modelSelected,
            swipeDeleted,
            didTapAddTask
        ])
        
        return .init(
            tasks: tasks,
            disposables: disposables
        )
    }
}
