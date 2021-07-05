//
//  TaskCell.swift
//  ToDoList
//
//  Created by Oleg Krikun on 22.06.2021.
//

import RxSwift
import RxCocoa
import PinLayout

final class TaskCellView: UITableViewCell {
    
    static let reuseIdentifier = String(describing: self)
    
    private var disposeBag = DisposeBag()

    private lazy var nameLabel = UILabel()
    private lazy var deadlineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
    }
    
    func configure(viewModel: TaskCellViewModelProtocol) {
        setupUI()
        bind(to: viewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        selectionStyle = .none
        separatorInset = .zero
        
        nameLabel.font = UIFont.boldSystemFont(
            ofSize: Appearance.fontSizeForNameTask
        )
        contentView.addSubview(nameLabel)
        
        deadlineLabel.textColor = .systemGray4
        deadlineLabel.font = UIFont.boldSystemFont(
            ofSize: Appearance.fontSizeForDeadlineTask
        )
        deadlineLabel.textAlignment = .right
        contentView.addSubview(deadlineLabel)
    }
    
    private func bind(to viewModel: TaskCellViewModelProtocol) {
        viewModel.nameTask
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.deadlineTask
            .drive(deadlineLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func performLayout() {
        nameLabel.pin
            .centerLeft(Appearance.sideIndentForInternalElements)
            .height(Appearance.heightForInternalElements)
            .width(Appearance.widthForNameTask)
        
        deadlineLabel.pin
            .after(of: nameLabel)
            .centerRight(Appearance.sideIndentForInternalElements)
            .height(Appearance.heightForInternalElements)
    }
}

extension TaskCellView {
    private enum Appearance {
        static var fontSizeForNameTask: CGFloat { 16 }
        static var fontSizeForDeadlineTask: CGFloat { 14 }
        static var sideIndentForInternalElements: CGFloat { 16 }
        
        static var heightForInternalElements: Percent { 100% }
        static var widthForNameTask: Percent { 70% }
    }
}
