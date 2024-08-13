//
//  MainButton.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

enum MainButtonType {
    case primary
    case secondary
    
    var style: MainButton.Style {
        switch self {
        case .secondary:
            MainButton.Style(ableBackgroundColor: .white, disableBackgroundColor: .white, textColor: .hankkiRed)
        default:
            MainButton.Style(ableBackgroundColor: .hankkiRed, disableBackgroundColor: .hankkiSemiRed, textColor: .white)
        }
    }
}

final class MainButton: UIButton {
    
    // MARK: - Properties
    
    struct Style {
        let ableBackgroundColor: UIColor
        let disableBackgroundColor: UIColor
        let textColor: UIColor
    }
    
    typealias ButtonAction = () -> Void
    
    let style: Style
    let titleText: String
    
    // disable이 가능한 버튼인지 결정합니다.
    // disable이 가능하면, 초기 설졍을 diable로 진행합니다.
    let isDisable: Bool
    
    var buttonHandler: ButtonAction?
    
    // MARK: - Life Cycle
    
    init(
        type: MainButtonType = .primary,
        frame: CGRect = .zero,
        titleText: String,
        isDisable: Bool = false,
        buttonHandler: ButtonAction? = nil
    ) {
        self.style = type.style
        self.titleText = titleText
        
        self.isDisable = isDisable
        
        self.buttonHandler = buttonHandler
        
        super.init(frame: frame)
        
        setupStyle()
        setupButtonAction()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainButton {
    func setupButtonAction() {
        self.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    @objc func buttonDidTap() {
        if let buttonHandler {
            return buttonHandler()
        }
    }
}

extension MainButton {
    func setupEnabledButton() {
        self.do {
            $0.backgroundColor = style.ableBackgroundColor
            $0.isEnabled = true
        }
    }
    
    func setupDisabledButton() {
        self.do {
            $0.backgroundColor = style.disableBackgroundColor
            $0.isEnabled = false
        }
    }
}

private extension MainButton {
    func setupStyle() {
        self.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: titleText,
                color: style.textColor
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            
            if isDisable {
                $0.backgroundColor = style.disableBackgroundColor
                $0.isEnabled = false
            } else {
                $0.backgroundColor = style.ableBackgroundColor
                $0.isEnabled = true
            }
            
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 0, borderColor: .clear)
        }
    }
}
