//
//  ListTasksProvider.swift
//  ToDoList
//
//  Created by Oleg Krikun on 02.07.2021.
//

import RxSwift
import RxCocoa

protocol ListTasksProviderProtocol {
    func getTasks() -> Single<[Task]>
    func delete(taskBy id: String) -> Completable
}

extension TaskService: ListTasksProviderProtocol { }
