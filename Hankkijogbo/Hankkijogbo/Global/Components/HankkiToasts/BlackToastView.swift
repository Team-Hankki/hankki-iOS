//
//  BlackToastView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

import SnapKit
import Then

final class BlackToastView: BaseView {
    
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
            $0.width.equalTo(343)
            $0.height.equalTo(49)
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
            $0.backgroundColor = UIColor.gray900.withAlphaComponent(0.85)
            $0.layer.cornerRadius = 6
        }
        messageLabel.do {
            $0.text = message
            $0.textColor = .white
            $0.font = .setupPretendardStyle(of: .body3)
        }
        actionButton.do {
            $0.setTitle("보기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .body4)
            $0.setUnderline()
            $0.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        }
    }
}

private extension BlackToastView {
    
    // MARK: - @objc
    
    @objc func actionButtonDidTap() {
        action()
    }
}
