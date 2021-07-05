//
//  FormContainerView.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

class FormContainerView: UIView {
    private(set) lazy var scrollView = UIScrollView()
    
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)

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

    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.pin.all()
    }

    private func keyboardWillShow(notification: Notification) {
        guard let sizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        setFormScrollView(bottomInset: sizeValue.cgRectValue.height)
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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
