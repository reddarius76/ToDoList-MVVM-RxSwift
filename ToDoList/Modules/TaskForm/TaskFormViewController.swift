//
//  TaskFormViewController.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa
import PinLayout

final class TaskFormViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    private lazy var taskView = TaskFormView()
    
    private let didTapSaveButton = PublishRelay<Void>()
    
    private let nameValue = BehaviorRelay<String>(value: Constants.emptyText)
    private let descriptionValue = BehaviorRelay<String>(value: Constants.emptyText)
    private let deadlineValue = BehaviorRelay<String>(value: Constants.emptyText)
    private let priorityValue = BehaviorRelay<String>(value: Constants.emptyText)
    
    override func viewDidLayoutSubviews() {
        taskView.pin.all()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
    }

    private func bindView() {
        taskView.tapForSaveButton
            .emit(to: didTapSaveButton)
            .disposed(by: disposeBag)
            
        taskView.textFromName
            .drive(nameValue)
            .disposed(by: disposeBag)
        
        taskView.textFromDescription
            .drive(descriptionValue)
            .disposed(by: disposeBag)
        
        taskView.textFromDeadline
            .drive(deadlineValue)
            .disposed(by: disposeBag)
        
        taskView.textFromPriority
            .drive(priorityValue)
            .disposed(by: disposeBag)
        
    }
    
    func bind(to viewModel: TaskFormViewModelProtocol) {
        
        let binding = TaskFormViewModel.UIBindings(
            didTapSaveButton: didTapSaveButton.asSignal(),
            nameValue: nameValue.asDriver(),
            descriptionValue: descriptionValue.asDriver(),
            deadlineValue: deadlineValue.asDriver(),
            priorityValue: priorityValue.asDriver()
        )
        
        let output = viewModel.transform(binding)
        title = output.isEditing
            ? Texts.titleForAddTask
            : Texts.titleForEditTask
        taskView.configure(task: output.task)

        output.disposables
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.addSubview(taskView)
        view.backgroundColor = .gray
        removeTitleFromBackButton()
    }
}

extension TaskFormViewController {
    private enum Texts {
        static var titleForAddTask: String { "Новая задача" }
        static var titleForEditTask: String { "Редактирование" }
    }
}

