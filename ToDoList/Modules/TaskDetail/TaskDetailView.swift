//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

final class TaskDetailView: FormContainerView {

    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var deadlineLabel = UILabel()
    private lazy var priorityLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    func configure(
        name: Driver<String>,
        description: Driver<String>,
        deadline: Driver<String>,
        priority: Driver<String>
    ) {
        name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        deadline
            .drive(deadlineLabel.rx.text)
            .disposed(by: disposeBag)
        priority
            .drive(priorityLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
        didPerformLayout()
    }
    
    private func setupUI() {
        descriptionLabel.numberOfLines = 0
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(deadlineLabel)
        scrollView.addSubview(priorityLabel)
    }

    private func performLayout() {
        nameLabel.pin
            .horizontally(Appearance.sideIndentForElements)
            .height(Appearance.heightForElements)
        
        descriptionLabel.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: nameLabel)
            .pinEdges()
            .sizeToFit(.width)
        
        deadlineLabel.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: descriptionLabel)
            .height(Appearance.heightForElements)
        
        priorityLabel.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: deadlineLabel)
            .height(Appearance.heightForElements)
    }
    
    private func didPerformLayout() {
        scrollView.contentSize = CGSize(
            width: bounds.width,
            height: scrollView.frame.maxY
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: performLayout)
    }
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TaskDetailView {
    private enum Appearance {
        static var sideIndentForElements: CGFloat { 16 }
        static var heightForElements: CGFloat { 40 }
    }
}

private enum Texts {
    static var nameTask: String { "Task name" }
    static var descriptionTask: String { "Description" }
    static var deadlineTask: String { "Deadline for completion" }
    static var priorityTask: String { "Priority" }
}
