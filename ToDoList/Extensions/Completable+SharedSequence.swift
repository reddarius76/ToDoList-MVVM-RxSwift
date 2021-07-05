//
//  Completable+SharedSequence.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

extension Completable {
    func andThen<Strategy: SharingStrategyProtocol, Element>(
        _ second: SharedSequence<Strategy, Element>
    ) -> SharedSequence<Strategy, Element> {
        andThen(second.asObservable())
            .asSharedSequence(onErrorRecover: { _ in .empty() })
    }
}
