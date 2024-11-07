//
//  DeleteMenuAccessoryView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/8/24.
//

import UIKit

/// - 메뉴 삭제를 추천하는 인풋 악세사리 뷰
class DeleteMenuAccessoryView: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)?
    
    var deleteButtonAction: ButtonAction
    var xButtonAction: ButtonAction
    
    // MARK: - UI Components
    
    private let topLabel: UILabel = UILabel()
    private let bottomLabel: UILabel = UILabel()
    private let deleteButton: UIButton = UIButton()
    private let xButton: UIButton = UIButton()
        
    // MARK: - Init
    
    init(deleteButtonAction: ButtonAction, xButtonAction: ButtonAction) {
        self.deleteButtonAction = deleteButtonAction
        self.xButtonAction = xButtonAction
        
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .gray50
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.makeRoundCorners(corners: [.topLeft, .topRight], radius: 12)
        }
        
        topLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body8,
                withText: StringLiterals.ModifyMenu.overPrice,
                color: .gray600
            )
        }
        
        bottomLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.ModifyMenu.recommendDeleteMenu,
                color: .gray850
            )
        }
        
        deleteButton.do {
            $0.backgroundColor = .warnRed
            $0.setAttributedTitle(
                UILabel.setupAttributedText(
                    for: PretendardStyle.body8,
                    withText: StringLiterals.Common.delete,
                    color: .hankkiWhite
                ),
                for: .normal
            )
            $0.layer.cornerRadius = 8
        }
        
        xButton.do {
            $0.setImage(.btnDeleteSmall, for: .normal)
        }
    }
    
    override func setupHierarchy() {
        addSubviews(
            topLabel,
            bottomLabel,
            deleteButton,
            xButton
        )
    }

    override func setupLayout() {
        topLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom)
            $0.leading.equalTo(topLabel)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(bottomLabel.snp.trailing).offset(42)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(61)
            $0.height.equalTo(32)
        }
        
        xButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
}

private extension DeleteMenuAccessoryView {
    
    func setupAddTarget() {
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
    }
    
    @objc func deleteButtonDidTap() {
        deleteButtonAction?()
    }
    
    @objc func xButtonDidTap() {
        xButtonAction?()
    }
}
