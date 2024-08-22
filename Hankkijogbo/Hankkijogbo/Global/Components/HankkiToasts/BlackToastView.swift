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
    @objc var action: ButtonAction?
    
    // MARK: - UI Properties
    
    private let messageLabel: UILabel = UILabel()
    private let actionButton: UIButton = UIButton()
    private let tapDetectView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    init(message: String, action: ButtonAction? = nil) {
        self.message = message
        self.action = action
        super.init(frame: .zero)
        
        addGesture()
        removeViewWithAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    override func setupHierarchy() {
        if action == nil {
            addSubview(messageLabel)
        } else {
            addSubviews(messageLabel, actionButton, tapDetectView)
        }
        print("✔️\(String(describing: self.superview)) \(message)")
    }
    
    override func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.getDeviceWidth() - 16*2)
            $0.height.equalTo(49)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            if action == nil {
                $0.centerX.equalToSuperview()
            } else {
                $0.leading.equalToSuperview().inset(22)
            }
        }
        
        if action != nil {
            actionButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(22)
            }
            
            tapDetectView.snp.makeConstraints {
                $0.centerY.trailing.width.equalTo(actionButton)
                $0.height.equalToSuperview()
            }
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
            $0.font = .setupPretendardStyle(of: .body4)
        }
        actionButton.do {
            $0.setTitle(StringLiterals.Toast.see, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .body5)
            $0.setUnderline()
        }
    }
}

private extension BlackToastView {
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionButtonDidTap))
        tapDetectView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - @objc
    
    @objc func actionButtonDidTap() {
        action?()
    }
}
