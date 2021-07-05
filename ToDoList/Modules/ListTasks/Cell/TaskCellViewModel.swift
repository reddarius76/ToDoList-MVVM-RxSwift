//
//  TaskCellViewModel.swift
//  ToDoList
//
//  Created by Oleg Krikun on 23.06.2021.
//

import RxSwift
import RxCocoa

protocol TaskCellViewModelProtocol {
    var nameTask: Driver<String> { get }
    var deadlineTask: Driver<String> { get }
    init(task: Task)
}

struct TaskCellViewModel: TaskCellViewModelProtocol {
    let nameTask: Driver<String>
    let deadlineTask: Driver<String>

    init(task: Task) {
        self.nameTask = .just(task.name)
        self.deadlineTask = .just(task.deadline)
    }
}
