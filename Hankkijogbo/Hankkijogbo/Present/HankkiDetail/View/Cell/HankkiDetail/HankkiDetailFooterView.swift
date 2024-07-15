//
//  HankkiDetailFooterView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailFooterView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    var isLiked: Bool = false
    var likedNumber: Int = 299
    var addMyZipString: String = "나의 족보에 추가"
    
    // MARK: - UI Components
    
    private lazy var footerButtonStackView: UIStackView = UIStackView()
    private lazy var likedButton: HankkiDetailButton = HankkiDetailButton()
    private lazy var addMyZipButton: HankkiDetailButton = HankkiDetailButton()
    
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
            $0.top.centerX.equalToSuperview()
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
        likedButton.do {
            $0.image = isLiked ? .btnLikeSelected24 : .btnLikeNormal24
            $0.text = "\(self.likedNumber)"
            $0.buttonHandler = likedButtonDidTap
        }
        addMyZipButton.do {
            $0.image = .btnAddFilled
            $0.text = self.addMyZipString
            $0.buttonHandler = addMyZipButtonDidTap
        }
    }
}

extension HankkiDetailFooterView {
    
    // MARK: - @objc Func
    
    @objc func likedButtonDidTap() {
        isLiked = !isLiked
        likedButton.image = isLiked ? .btnLikeSelected24 : .btnLikeNormal24
        likedNumber += isLiked ? 1 : -1
    }
    
    @objc func addMyZipButtonDidTap() {
        // 나의 식당 족보 바텀 시트 up
        print("나의 식당 족보 바텀 시트 up")
    }
}
