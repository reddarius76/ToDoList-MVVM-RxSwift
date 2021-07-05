//
//  ListTasksViewController.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa
import PinLayout

final class ListTasksViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(
            TaskCellView.self,
            forCellReuseIdentifier: TaskCellView.reuseIdentifier
        )
        return tableView
    }()
    
    private let didTapAddTask = PublishRelay<Void>()
    
    override func viewDidLayoutSubviews() {
        taskTableView.pin.all()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(taskTableView)
        
        title = Constants.appName
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        
        view.backgroundColor = .gray
        bindView()
    }
    
    private func bindView() {
        navigationItem.rightBarButtonItem?.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: didTapAddTask)
            .disposed(by: disposeBag)
    }
    
    func bind(to viewModel: ListTasksViewModelProtocol) {

        let binding = ListTasksViewModel.UIBindings(
            modelSelected: taskTableView.rx.modelSelected(Task.self),
            swipeDeleted: taskTableView.rx.itemDeleted,
            didTapAddTask: didTapAddTask.asSignal()
        )
        
        let output = viewModel.transform(binding)
        
        output.tasks
            .drive(taskTableView.rx
                    .items(
                        cellIdentifier: TaskCellView.reuseIdentifier,
                        cellType: TaskCellView.self
                    )
            ) { (row, task, cell) in
                cell.configure(viewModel: TaskCellViewModel(task: task))
            }
            .disposed(by: disposeBag)
        
        output.disposables
            .disposed(by: disposeBag)
    }
}
