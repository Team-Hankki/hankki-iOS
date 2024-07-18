//
//  HankkiDetailFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailFooterView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    var isLiked: Bool = false {
        didSet {
            setupLikedButtonImage()
        }
    }
    var likedNumber: Int = -1 {
        didSet {
            setupLikeButtonStyle()
        }
    }
    var addMyZipString: String = "나의 족보에 추가"
    
    // MARK: - UI Components
    
    private lazy var footerButtonStackView: UIStackView = UIStackView()
    private lazy var likedButton: HankkiDetailButton = HankkiDetailButton(
        image: isLiked ? .btnLikeSelected24 : .btnLikeNormal24,
        text: "\(self.likedNumber)",
        buttonHandler: likedButtonDidTap
    )
    lazy var addMyZipButton: HankkiDetailButton = HankkiDetailButton(
        image: .btnAddDetail,
        text: self.addMyZipString,
        buttonHandler: nil
    )
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        self.addSubview(footerButtonStackView)
        footerButtonStackView.addArrangedSubviews(
            likedButton,
            addMyZipButton
        )
    }
    
    override func setupLayout() {
        footerButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
            $0.height.equalTo(42)
        }
        likedButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.lessThanOrEqualTo(105)
            $0.height.equalTo(42)
        }
        addMyZipButton.snp.makeConstraints {
            $0.centerY.equalTo(likedButton)
            $0.leading.equalTo(likedButton.snp.trailing).offset(12)
            $0.width.lessThanOrEqualTo(150)
            $0.height.equalTo(42)
        }
    }
    
    override func setupStyle() {
        footerButtonStackView.do {
            $0.spacing = 12
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .top
        }
    }
}

extension HankkiDetailFooterView {
    
    func setupLikeButtonStyle() {
        likedButton.hankkiDetailButton.setAttributedTitle(
            UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: "\(likedNumber)",
                color: .gray500
            ),
            for: .normal
        )
    }
    
    func setupLikedButtonImage() {
        likedButton.hankkiDetailButton.setImage(
            isLiked ? .btnLikeSelected24 : .btnLikeNormal24,
            for: .normal
        )
    }
    
    // MARK: - @objc Func
    
    @objc func likedButtonDidTap() {
        isLiked = !isLiked
        setupLikedButtonImage()
        
        likedNumber += isLiked ? 1 : -1
        setupLikeButtonStyle()
    }
}
