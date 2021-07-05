//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa
import PinLayout

final class TaskDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var taskDetailView = TaskDetailView()
    
    private let didTapAddTask = PublishRelay<Void>()
    private let didTapEditTask = PublishRelay<Void>()
    
    override func viewDidLayoutSubviews() {
        taskDetailView.pin.all()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(taskDetailView)
        
        let addTask = UIBarButtonItem(systemItem: .add)
        let editTask = UIBarButtonItem(systemItem: .edit)
        navigationItem.rightBarButtonItems = [addTask, editTask]
        
        view.backgroundColor = .gray
        
        removeTitleFromBackButton()
        bindView()
    }
    
    func bind(to viewModel: TaskDetailViewModelProtocol) {
        let binding = TaskDetailViewModel.Binding(
            didTapAddTask: didTapAddTask.asSignal(),
            didTapEditTask: didTapEditTask.asSignal()
        )
        
        let output = viewModel.transform(binding)
        taskDetailView.configure(
            name: output.nameTask,
            description: output.descriptionTask,
            deadline: output.deadlineTask,
            priority: output.priorityTask
        )
        
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        output.disposables
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        navigationItem.rightBarButtonItems?.first?.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: didTapAddTask)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItems?.last?.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: didTapEditTask)
            .disposed(by: disposeBag)
    }
}
