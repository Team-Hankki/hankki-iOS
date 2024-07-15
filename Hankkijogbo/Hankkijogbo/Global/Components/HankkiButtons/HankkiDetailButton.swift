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
    
    private let hankkiDetailButton: UIButton = UIButton()
    
    // MARK: - Init
    
    init(
        image: UIImage = .init(),
        text: String = "",
        buttonHandler: ButtonAction? = nil
    ) {
        self.image = image
        self.text = text
        self.buttonHandler = buttonHandler
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupStyle() {
        hankkiDetailButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: text,
                color: .gray500
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            $0.setImage(image, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 10
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray100.cgColor
        }
    }
    
    override func setupHierarchy() {
        self.addSubview(hankkiDetailButton)
    }
    
    override func setupLayout() {
        hankkiDetailButton.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(42)
        }
    }
}

private extension HankkiDetailButton {
    
    @objc func hankkiDetailButtonDidTap() {
        if let buttonHandler {
            return buttonHandler()
        }
    }
    
    func setupAddTarget() {
        hankkiDetailButton.addTarget(self, action: #selector(hankkiDetailButtonDidTap), for: .touchUpInside)
    }
}
