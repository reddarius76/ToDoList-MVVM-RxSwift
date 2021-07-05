//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Oleg Krikun on 26.06.2021.
//

import XCTest
import RxSwift
@testable import ToDoList


class MemoryTestRx: XCTestCase {
    private var startResourceCount: Int32 = 0
    
    override func setUp() {
        self.startResourceCount = Resources.total
    }
    
    override func tearDown() {
        if startResourceCount != Resources.total {
            print("⚡️Initial number of resources for Rx: \(startResourceCount)⚡️")
            print("⚡️Final number of resources for Rx: \(Resources.total)⚡️")
        }
        XCTAssertEqual(startResourceCount, Resources.total)
    }
}

final class ToDoListTestsForMemoryLeak: MemoryTestRx {

    func testLeakMemoryForListTasksVC() throws {
        autoreleasepool {
            _ = ListTasksViewController()
        }
    }

    func testLeakMemoryForTaskDetailVC() throws {
        autoreleasepool {
            let vc = TaskDetailViewController()
            let vm = TaskDetailViewModel(
                task: .init(
                    name: "Task 1",
                    description: "Description 1",
                    deadline: "01.05.2000",
                    priority: "High"
                ),
                router: TaskDetailRouter(vc)
            )
            vc.bind(to: vm)
        }
    }
    
    func testLeakMemoryForTaskFormVC() throws {
        autoreleasepool {
            let vc = TaskFormViewController()
            let vm = TaskFormViewModel(
                task: .init(
                    name: "Task 1",
                    description: "Description 1",
                    deadline: "01.05.2000",
                    priority: "High"
                ),
                router: TaskFormRouter(vc),
                provider: TaskService.shared
            )
            vc.bind(to: vm)
        }
    }
    
    func testLeakMemoryForTaskFormVCWithOutTask() throws {
        autoreleasepool {
            let vc = TaskFormViewController()
            let vm = TaskFormViewModel(
                task: nil,
                router: TaskFormRouter(vc),
                provider: TaskService.shared
            )
            TaskFormViewController().bind(to: vm)
        }
    }
}
