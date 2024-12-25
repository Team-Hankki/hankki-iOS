//
//  BottomButtonView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class BottomButtonView: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    var primaryButtonText: String {
        didSet {
            setupStyle()
        }
    }
    let lineButtonText: String
    let leftButtonText: String
    let rightButtonText: String
    
    var primaryButtonHandler: ButtonAction?
    var lineButtonHandler: ButtonAction?
    var leftButtonHandler: ButtonAction?
    var rightButtonHandler: ButtonAction?
    var gradientColor: UIColor
    
    // MARK: - UI Properties
    
    private let primaryButton: UIButton = UIButton()
    private let lineButton: UIButton = UIButton()
    private let leftButton: UIButton = UIButton()
    private let separatorView: UIView = UIView()
    private let rightButton: UIButton = UIButton()
    
    private let bottomButtonViewGradient = UIView()
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         primaryButtonText: String,
         lineButtonText: String = "",
         leftButtonText: String = "",
         rightButtonText: String = "",
         primaryButtonHandler: ButtonAction? = nil,
         lineButtonHandler: ButtonAction? = nil,
         leftButtonHandler: ButtonAction? = nil,
         rightButtonHandler: ButtonAction? = nil,
         gradientColor: UIColor = .hankkiWhite
    ) {
        self.primaryButtonText = primaryButtonText
        self.lineButtonText = lineButtonText
        self.leftButtonText = leftButtonText
        self.rightButtonText = rightButtonText
        self.primaryButtonHandler = primaryButtonHandler
        self.lineButtonHandler = lineButtonHandler
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.gradientColor = gradientColor
        super.init(frame: frame)
        
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBottomButtonViewGradient()
    }
    
    override func setupStyle() {
        primaryButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: primaryButtonText,
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.backgroundColor = .red400
            $0.layer.cornerRadius = 16
            $0.isEnabled = false
        }
        
        lineButton.do {
            $0.setTitle(lineButtonText, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .button)
            $0.setTitleColor(.gray400, for: .normal)
            $0.setUnderline()
        }
        
        if !leftButtonText.isEmpty && !rightButtonText.isEmpty {
            leftButton.do {
                if let attributedTitle = UILabel.setupAttributedText(
                    for: PretendardStyle.body2,
                    withText: leftButtonText,
                    color: .hankkiWhite
                ) {
                    $0.setAttributedTitle(attributedTitle, for: .normal)
                }
                $0.setImage(.icDeleteMenu, for: .normal)
                $0.configuration = .plain()
                $0.configuration?.imagePadding = 2
            }
            
            separatorView.do {
                $0.backgroundColor = .brownSeparator
            }
            
            rightButton.do {
                if let attributedTitle = UILabel.setupAttributedText(
                    for: PretendardStyle.body2,
                    withText: rightButtonText,
                    color: .hankkiWhite
                ) {
                    $0.setAttributedTitle(attributedTitle, for: .normal)
                }
                $0.setImage(.icModifyMenu, for: .normal)
                $0.configuration = .plain()
                $0.configuration?.imagePadding = 2
            }
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(
            bottomButtonViewGradient,
            primaryButton
        )
        
        if !lineButtonText.isEmpty {
            self.addSubview(lineButton)
        }
        if !leftButtonText.isEmpty && !rightButtonText.isEmpty {
            primaryButton.addSubviews(
                leftButton,
                separatorView,
                rightButton
            )
        }
    }
    
    override func setupLayout() {
        bottomButtonViewGradient.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(154)
        }
        
        primaryButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(54)
        }
        
        if !lineButtonText.isEmpty {
            lineButton.snp.makeConstraints {
                $0.top.equalTo(primaryButton.snp.bottom).offset(14)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(18)
            }
        }
        
        if !leftButtonText.isEmpty && !rightButtonText.isEmpty {
            leftButton.snp.makeConstraints {
                $0.centerY.height.equalToSuperview()
                $0.leading.equalToSuperview().inset(10)
                $0.width.equalTo((UIScreen.getDeviceWidth() - 26 - 41) / 2)
            }
            
            separatorView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(1)
                $0.height.equalTo(24)
            }
            
            rightButton.snp.makeConstraints {
                $0.centerY.height.equalToSuperview()
                $0.trailing.equalToSuperview().inset(10)
                $0.width.equalTo((UIScreen.getDeviceWidth() - 26 - 41) / 2)
            }
        }
    }
}

private extension BottomButtonView {
    
    func setupBottomButtonViewGradient() {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                gradientColor.withAlphaComponent(0).cgColor,
                gradientColor.cgColor,
                gradientColor.cgColor
            ]
            $0.locations = [0.0, 0.3, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            $0.frame = self.bounds
        }
        
        bottomButtonViewGradient.layer.addSublayer(gradient)
    }
    
    @objc func primaryButtonDidTap() {
        if let primaryButtonHandler {
            return primaryButtonHandler()
        }
    }
    
    @objc func lineButtonDidTap() {
        if let lineButtonHandler {
            return lineButtonHandler()
        }
    }
    
    @objc func leftButtonDidTap() {
        if let leftButtonHandler {
            return leftButtonHandler()
        }
    }
    
    @objc func rightButtonDidTap() {
        if let rightButtonHandler {
            return rightButtonHandler()
        }
    }
    
    func setupButtonAction() {
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(lineButtonDidTap), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
    }
}

extension BottomButtonView {
    // TODO: - 서현) button text 관련해서 고민해봅시다...
    func setupEnabledDoneButton(primaryButtonText: String = "") {
        primaryButton.do {
            $0.backgroundColor = .red500
            $0.isEnabled = true
        }
        
        if !primaryButtonText.isEmpty {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: primaryButtonText,
                color: .hankkiWhite
            ) {
                primaryButton.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    func setupDisabledDoneButton(primaryButtonText: String = "") {
        primaryButton.do {
            $0.backgroundColor = .red400
            $0.isEnabled = false
        }
        
        if !primaryButtonText.isEmpty {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: primaryButtonText,
                color: .hankkiWhite
            ) {
                primaryButton.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
}
