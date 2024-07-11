//
//  MainButton.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

final class MainButton: UIButton {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    let titleText: String
    var buttonHandler: ButtonAction?
    
    // MARK: - UI Properties
    
    // MARK: - Life Cycle
    
    init(
        frame: CGRect = .zero,
        titleText: String,
        buttonHandler: ButtonAction? = nil
    ) {
        self.titleText = titleText
        self.buttonHandler = buttonHandler
        
        super.init(frame: frame)
        
        setupStyle()
        setupButtonAction()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupStyle() {
        self.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: titleText,
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.backgroundColor = .hankkiRedLight2
            $0.layer.cornerRadius = 16
            $0.isEnabled = false
        }
    }
}

extension MainButton {
    @objc func buttonDidTap() {
        if let buttonHandler {
            return buttonHandler()
        }
    }
    
    func setupButtonAction() {
        self.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
}

extension MainButton {
    func setupEnabledButton() {
        self.do {
            $0.backgroundColor = .hankkiRed
            $0.isEnabled = true
        }
    }
    
    func setupDisabledButton() {
        self.do {
            $0.backgroundColor = .hankkiRedLight2
            $0.isEnabled = false
        }
    }
}
