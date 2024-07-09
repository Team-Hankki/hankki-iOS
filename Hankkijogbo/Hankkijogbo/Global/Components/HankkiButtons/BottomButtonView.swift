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
    
    let primaryButtonText: String
    let lineButtonText: String
    
    var primaryButtonHandler: ButtonAction?
    var lineButtonHandler: ButtonAction?
    
    // MARK: - UI Properties
    
    private let primaryButton: UIButton = UIButton()
    private let lineButton: UIButton = UIButton()
    
    private let bottomButtonViewGradient = UIView()
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         primaryButtonText: String,
         lineButtonText: String = "",
         primaryButtonHandler: ButtonAction? = nil,
         lineButtonHandler: ButtonAction? = nil
    ) {
        self.primaryButtonText = primaryButtonText
        self.lineButtonText = lineButtonText
        self.primaryButtonHandler = primaryButtonHandler
        self.lineButtonHandler = lineButtonHandler
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
            $0.backgroundColor = .hankkiRedLight2
            $0.layer.cornerRadius = 16
            $0.isEnabled = false
        }
        
        lineButton.do {
            $0.setTitle(lineButtonText, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .button)
            $0.setTitleColor(.gray400, for: .normal)
            $0.setUnderline()
        }
    }
    
    override func setupHierarchy() {
        self.addSubviews(
            bottomButtonViewGradient
        )
        if !primaryButtonText.isEmpty {
            self.addSubview(primaryButton)
        }
        if !lineButtonText.isEmpty {
            self.addSubview(lineButton)
        }
    }
    
    override func setupLayout() {
        bottomButtonViewGradient.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(154)
        }

        if !primaryButtonText.isEmpty {
            primaryButton.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(50)
                $0.leading.trailing.equalToSuperview().inset(22)
                $0.height.equalTo(54)
            }
        }
        
        if !lineButtonText.isEmpty {
            lineButton.snp.makeConstraints {
                $0.top.equalTo(primaryButton.snp.bottom).offset(14)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(18)
            }
        }
    }
}

private extension BottomButtonView {
    func setupBottomButtonViewGradient() {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.white.withAlphaComponent(0).cgColor,
                UIColor.white.cgColor,
                UIColor.white.cgColor
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
    
    func setupButtonAction() {
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(lineButtonDidTap), for: .touchUpInside)
    }
   
}

extension BottomButtonView {
    func setupEnabledDoneButton() {
        primaryButton.do {
            $0.backgroundColor = .hankkiRed
            $0.isEnabled = true
        }
    }
    
    func setupDisabledDoneButton() {
        primaryButton.do {
            $0.backgroundColor = .hankkiRedLight
            $0.isEnabled = false
        }
    }
}

