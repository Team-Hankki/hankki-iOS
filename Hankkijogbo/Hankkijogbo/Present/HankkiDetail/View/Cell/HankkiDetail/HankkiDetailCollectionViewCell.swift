//
//  HankkiDetailCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    private let menuNameMaxLength: Int = 11
    
    // MARK: - UI Components
    
    private var hankkiMenuNameLabel: UILabel = UILabel()
    private let dottedLineView: DottedLineView = DottedLineView(frame: CGRect(x: 0, y: 0, width: 0, height: 4))
    private let hankkiMenuPriceLabel: UILabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(
            hankkiMenuNameLabel,
            dottedLineView,
            hankkiMenuPriceLabel
        )
    }
    
    override func setupLayout() {
        hankkiMenuNameLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        dottedLineView.snp.makeConstraints {
            $0.leading.equalTo(hankkiMenuNameLabel.snp.trailing).offset(27)
            $0.trailing.equalTo(hankkiMenuPriceLabel.snp.leading).offset(-27)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(2)
        }
        hankkiMenuPriceLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        hankkiMenuNameLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                color: .gray700
            )
        }
        dottedLineView.do {
            $0.clipsToBounds = true
        }
        hankkiMenuPriceLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body1,
                color: .gray500
            )
        }
    }
}

private extension HankkiDetailCollectionViewCell {
    /// 메뉴 이름 길이에 따라 label text를 다르게 업데이트
    func updateMenuNameLabel(name: String) {
        /// 최대 길이를 넘는다면 crop
        if name.count > menuNameMaxLength {
            hankkiMenuNameLabel.text = name.getTruncatedTailString(limit: menuNameMaxLength)
        } else {
            hankkiMenuNameLabel.text = name
        }
    }
    
    /// 메뉴 이름 길이에 맞게 dottedLineView의 레이아웃 업데이트
    func updateDottedLineViewLayout(by menuName: String) {
        let length = min(menuName.count, menuNameMaxLength)
        dottedLineView.snp.updateConstraints {
            $0.leading.equalTo(hankkiMenuNameLabel.snp.trailing).offset(27 - (length - 1) * 2)
            $0.trailing.equalTo(hankkiMenuPriceLabel.snp.leading).offset(-(27 - (length - 1) * 2))
            $0.centerY.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

extension HankkiDetailCollectionViewCell {
    func bindMenuData(_ menuData: MenuData) {
        updateMenuNameLabel(name: menuData.name)
        hankkiMenuPriceLabel.formattingPrice(price: menuData.price)
        updateDottedLineViewLayout(by: menuData.name)
    }
}
