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
            MainButton.Style(ableBackgroundColor: .white, disableBackgroundColor: .white, textColor: .red500)
        default:
            MainButton.Style(ableBackgroundColor: .red500, disableBackgroundColor: .red400, textColor: .white)
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
    
    private let style: Style
    private let titleText: String
    
    private var isValid: Bool {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateStyle()
            }
        }
    }
    
    private var isSubmitted: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("제출중...")
            }
        }
    }
    
    var buttonHandler: ButtonAction?
    
    // MARK: - Life Cycle
    
    init(
        type: MainButtonType = .primary,
        frame: CGRect = .zero,
        titleText: String,
        isValid: Bool = true,
        buttonHandler: ButtonAction? = nil
    ) {
        self.style = type.style
        self.titleText = titleText
        
        self.buttonHandler = buttonHandler
        self.isValid = isValid
        
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
    func setupIsValid(_ isValid: Bool) {
        self.isValid = isValid
    }
    
    func setupIsSubmitted(_ isSubmitted: Bool) {
        self.isSubmitted = isSubmitted
    }
    //
    //    func setupEnabledButton() {
    //        self.do {
    //            $0.backgroundColor = style.ableBackgroundColor
    //            $0.isEnabled = true
    //        }
    //    }
    //
    //    func setupDisabledButton() {
    //        self.do {
    //            $0.backgroundColor = style.disableBackgroundColor
    //            $0.isEnabled = false
    //        }
    //    }
}

private extension MainButton {
    func updateStyle() {
        self.do {
            if isValid {
                // 버튼이 유효한 경우 = enable
                $0.backgroundColor = style.ableBackgroundColor
                $0.isEnabled = true
            } else {
                // 버튼이 유효하지 않은 경우 = disable
                $0.backgroundColor = style.disableBackgroundColor
                $0.isEnabled = false
            }
        }
    }
    
    func setupStyle() {
        self.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: titleText,
                color: style.textColor
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 0, borderColor: .clear)
        }
        
        updateStyle()
    }
}
