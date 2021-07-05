//
//  TaskService.swift
//  ToDoList
//
//  Created by Oleg Krikun on 29.06.2021.
//

import RxSwift
import RxCocoa

final class TaskService {
    static let shared = TaskService()
    
    private let tasksRelay = BehaviorRelay<[Task]>(value: MockTasks.tasks)
    
    func getTasks() -> Single<[Task]> {
        tasksRelay.take(1).asSingle()
    }
    
    func add(task: Task) -> Completable {
        Completable.create { [unowned self] completable in
            var tasks = tasksRelay.value
            tasks.append(task)
            tasksRelay.accept(tasks)
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    func edit(task: Task) -> Completable {
        Completable.create { [unowned self] completable in
            var tasks = tasksRelay.value
            let indexTask = tasks.firstIndex {
                $0.id == task.id
            }
            
            if let indexTask = indexTask {
                tasks[indexTask] = task
                tasksRelay.accept(tasks)
                completable(.completed)
            } else {
                completable(.error(TaskError.invalidId))
            }

            return Disposables.create {}
        }
    }
    
    func delete(taskBy id: String) -> Completable {
        Completable.create { [unowned self] completable in
            var tasks = tasksRelay.value
            let indexTask = tasks.firstIndex {
                $0.id == id
            }
            
            if let indexTask = indexTask {
                tasks.remove(at: indexTask)
                tasksRelay.accept(tasks)
                completable(.completed)
            } else {
                completable(.error(TaskError.invalidId))
            }
    
            return Disposables.create {}
        }
    }
    
    private init() {}
}

extension TaskService {
    private enum MockTasks {
        static var tasks: [Task] {
            [
                Task(
                    name: "Task 1: Shopping",
                    description: "Go to the grocery store",
                    deadline: "30.06.2021",
                    priority: "Middle"
                ),
                Task(
                    name: "Task 2: Project",
                    description: "Upload a pet project",
                    deadline: "1.07.2021",
                    priority: "High"
                ),
                Task(
                    name: "Task 3: Meeting",
                    description: "Meet with friends",
                    deadline: "5.07.2021",
                    priority: "Low"
                )
            ]
        }
    }
}

extension TaskService {
    private enum TaskError: Error {
        case invalidId
    }
}

