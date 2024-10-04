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
    var likedNumber: Int = 0 {
        didSet {
            setupLikeButtonStyle()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var footerButtonStackView: UIStackView = UIStackView()
    lazy var likedButton: HankkiDetailButton = HankkiDetailButton(
        image: isLiked ? .btnLikeSelected : .btnLikeNormal,
        text: "\(self.likedNumber)"
    )
    lazy var addMyZipButton: HankkiDetailButton = HankkiDetailButton(
        image: .btnAddDetail,
        text: StringLiterals.MyZip.addToMyZip
    )
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        self.addSubview(footerButtonStackView)
        footerButtonStackView.addArrangedSubviews(likedButton, addMyZipButton)
    }
    
    override func setupLayout() {
        footerButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(42)
        }
        likedButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.38)
            $0.height.equalToSuperview()
        }
        addMyZipButton.snp.makeConstraints {
            $0.centerY.equalTo(likedButton)
            $0.leading.equalTo(likedButton.snp.trailing).offset(12)
            $0.width.equalToSuperview().multipliedBy(0.57)
            $0.height.equalToSuperview()
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
                for: PretendardStyle.body6,
                withText: "\(likedNumber)",
                color: .gray500
            ),
            for: .normal
        )
    }
    
    func setupLikedButtonImage() {
        likedButton.hankkiDetailButton.setImage(
            isLiked ? .btnLikeSelected : .btnLikeNormal,
            for: .normal
        )
    }
        
    func updateLikeButtonStatus() {
        isLiked = !isLiked
        likedNumber += isLiked ? 1 : -1
    }
}
