//
//  HankkiDetailButton.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailButton: BaseView {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    var image: UIImage
    var text: String
    var buttonHandler: ButtonAction?
    
    // MARK: - UI Components
    
    let hankkiDetailButton: UIButton = UIButton()
    
    // MARK: - Init
    
    init(
        image: UIImage,
        text: String,
        buttonHandler: ButtonAction? = nil
    ) {
        self.image = image
        self.text = text
        self.buttonHandler = buttonHandler
        super.init(frame: .zero)
        
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupStyle() {
        hankkiDetailButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: text,
                color: .gray500
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(image, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 10
            $0.backgroundColor = .hankkiWhite
            $0.makeRoundBorder(cornerRadius: 10, borderWidth: 1, borderColor: .gray100)
        }
    }
    
    override func setupHierarchy() {
        addSubview(hankkiDetailButton)
    }
    
    override func setupLayout() {
        hankkiDetailButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(105)
            $0.height.equalTo(42)
        }
    }
}

private extension HankkiDetailButton {
    
    func setupAddTarget() {
        hankkiDetailButton.addTarget(self, action: #selector(hankkiDetailButtonDidTap), for: .touchUpInside)
    }
    
    @objc func hankkiDetailButtonDidTap() {
        if let buttonHandler {
            return buttonHandler()
        }
    }
}
