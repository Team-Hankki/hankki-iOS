//
//  WhiteToastView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/8/24.
//

import UIKit

import SnapKit
import Then

final class WhiteToastView: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)
    
    var message: String
    @objc var action: ButtonAction
    
    // MARK: - UI Properties
    
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(message: String, action: @escaping ButtonAction) {
        self.message = message
        self.action = action
        super.init(frame: .zero)
        
        addShadow(
            color: .black.withAlphaComponent(0.18),
            opacity: 1,
            radius: 18,
            offset: CGSize(width: 0, height: 6)
        )
        removeToastWithAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    override func setupHierarchy() {
        addSubviews(messageLabel, actionButton)
    }
    
    override func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(242)
            $0.height.equalTo(52)
        }
        messageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(22)
        }
        actionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
        }
        messageLabel.do {
            $0.text = message
            $0.textColor = .gray800
            $0.font = .setupPretendardStyle(of: .subtitle3)
        }
        actionButton.do {
            $0.setTitle("이동", for: .normal)
            // TODO: - 색 이름 한끼레드로 변경되면 적용해야 됨
            $0.setTitleColor(.red, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .subtitle3)
            $0.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        }
    }
}

private extension WhiteToastView {
    
    // MARK: - @objc
    
    @objc func actionButtonDidTap() {
        action()
    }
}
