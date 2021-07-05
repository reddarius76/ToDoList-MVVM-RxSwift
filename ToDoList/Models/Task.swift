//
//  Task.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import Foundation

struct Task {
    private(set) var id: String = UUID().uuidString
    var name: String
    var description: String
    var deadline: String
    var priority: String
    
    
    static var empty: Task {
        .init(
            name: Constants.emptyText,
            description: Constants.emptyText,
            deadline: Constants.emptyText,
            priority: Constants.emptyText
        )
    }
}
