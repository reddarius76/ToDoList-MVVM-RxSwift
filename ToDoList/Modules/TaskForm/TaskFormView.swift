//
//  TaskView.swift
//  ToDoList
//
//  Created by Oleg Krikun on 23.06.2021.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

final class TaskFormView: UIView {
    
    var textFromName: Driver<String> { nameTF.rx.textOrEmpty }
    var textFromDescription: Driver<String> { descriptionTF.rx.textOrEmpty }
    var textFromDeadline: Driver<String> { deadlineTF.rx.textOrEmpty }
    var textFromPriority: Driver<String> { priorityTF.rx.textOrEmpty }
    var tapForSaveButton: Signal<Void> { saveButton.rx.tap.asSignal() }
    
    private let scrollView = UIScrollView()
    private let nameTF = UITextField()
    private let descriptionTF = UITextField()
    private let deadlineTF = UITextField()
    private let priorityTF = UITextField()
    private let saveButton = UIButton()
    
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        addSubview(scrollView)
        
        saveButton.setTitle(Appearance.titleForSaveButton, for: .normal)
        saveButton.backgroundColor = .blue
        addSubview(saveButton)

        nameTF.placeholder = Appearance.placeholderForNameTask
        nameTF.borderStyle = .line
        scrollView.addSubview(nameTF)

        descriptionTF.placeholder = Appearance.placeholderForDescriptionTask
        descriptionTF.borderStyle = .line
        scrollView.addSubview(descriptionTF)

        deadlineTF.placeholder = Appearance.placeholderForDeadlineTask
        deadlineTF.borderStyle = .line
        scrollView.addSubview(deadlineTF)

        priorityTF.placeholder = Appearance.placeholderForPriorityTask
        priorityTF.borderStyle = .line
        scrollView.addSubview(priorityTF)
        
        setupScrollView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
        didPerformLayout()
    }
    
    func configure(task: Driver<Task>) {
        task.drive { [unowned self] in
            self.nameTF.text = $0.name
            self.descriptionTF.text = $0.description
            self.deadlineTF.text = $0.deadline
            self.priorityTF.text = $0.priority
        }
        .disposed(by: disposeBag)
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        
        let tap = UITapGestureRecognizer()
        tap.rx.event
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.didTapScrollView()
            })
            .disposed(by: disposeBag)
        addSubview(scrollView)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: keyboardWillShow)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: keyboardWillHide)
            .disposed(by: disposeBag)
    }
    
    private func keyboardWillShow(notification: Notification) {
        guard let sizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        setFormScrollView(bottomInset: sizeValue.cgRectValue.height - Appearance.paddingBetweenKeyboardAndElement)
    }

    private func keyboardWillHide(notification: Notification) {
        resetScrollOffset()
    }

    private func didTapScrollView() {
        endEditing(true)
        resetScrollOffset()
    }

    private func resetScrollOffset() {
        guard scrollView.contentInset != .zero else { return }
        setFormScrollView(bottomInset: 0)
    }

    private func setFormScrollView(bottomInset: CGFloat) {
        scrollView.contentInset = UIEdgeInsets(
            top: scrollView.contentInset.top,
            left: 0,
            bottom: bottomInset,
            right: 0
        )
    }
    
    private func performLayout() {
        saveButton.pin
            .bottom(pin.safeArea)
            .horizontally()
            .height(Appearance.heightForSaveButton)
        
        scrollView.pin
            .top(pin.safeArea)
            .horizontally()
            .bottom(to: saveButton.edge.top)
        
        nameTF.pin
            .horizontally(Appearance.sideIndentForElements)
            .sizeToFit(.width)
            .top(to: scrollView.edge.top)
            .marginTop(Appearance.topIndentForElements)
        
        descriptionTF.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: nameTF)
            .sizeToFit(.width)
            .marginTop(Appearance.topIndentForElements)
        
        deadlineTF.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: descriptionTF)
            .sizeToFit(.width)
            .marginTop(Appearance.topIndentForElements)
        
        priorityTF.pin
            .horizontally(Appearance.sideIndentForElements)
            .below(of: deadlineTF)
            .sizeToFit(.width)
            .marginTop(Appearance.topIndentForElements)
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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskFormView {
    private enum Appearance {
        static var sideIndentForElements: CGFloat { 16 }
        static var topIndentForElements: CGFloat { 8 }
        static var heightForSaveButton: CGFloat { 55 }
        static var paddingBetweenKeyboardAndElement: CGFloat { 48 }
        
        static var titleForSaveButton: String { "Save" }
        static var placeholderForNameTask: String { "Enter name of the task" }
        static var placeholderForDescriptionTask: String { "Enter description of the task" }
        static var placeholderForDeadlineTask: String { "Enter deadline of the task" }
        static var placeholderForPriorityTask: String { "Enter priority of the task" }
    }
}

private extension Reactive where Base: UITextField {
    
    var textOrEmpty: Driver<String> {
        text.asDriver()
            .map { $0 ?? "" }
    }
}
