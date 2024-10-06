//
//  moreButton.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/15/24.
//

import UIKit

final class MoreButton: UIButton {
    
    // MARK: - Properties
    
    typealias ButtonAction = (() -> Void)
    
    private let buttonText: String?
    private let buttonAction: ButtonAction?
    
    // MARK: - Life Cycle
    
    init(
        buttonText: String? = nil,
        buttonAction: ButtonAction? = nil
    ) {
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        
        super.init(frame: .zero)
        
        setupStyle()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MoreButton {
    func setupStyle() {
        self.do {
            $0.makeRoundBorder(cornerRadius: 14, borderWidth: 0, borderColor: .clear)
            $0.setupPadding(top: 10 + 1.5, leading: 18, bottom: 10 + 1.5, trailing: 18)
            $0.setupBackgroundColor(.gray100)
            $0.setupIcon(.icAddGray, gap: 5)
            
            if let attributedTitle = UILabel.setupAttributedText(for: PretendardStyle.body4, withText: buttonText ?? "", color: .gray500) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    func setupAddTarget() {
        self.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    @objc func buttonDidTap() {
        buttonAction?()
    }
}
