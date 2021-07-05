//
//  TaskFormProvider.swift
//  ToDoList
//
//  Created by Oleg Krikun on 02.07.2021.
//

import RxSwift
import RxCocoa

protocol TaskFormProviderProtocol {
    func add(task: Task) -> Completable
    func edit(task: Task) -> Completable
}

extension TaskService: TaskFormProviderProtocol { }
