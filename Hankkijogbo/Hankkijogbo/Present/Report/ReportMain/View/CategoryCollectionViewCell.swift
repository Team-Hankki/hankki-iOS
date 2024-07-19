//
//  CategoryCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(categoryImageView, categoryLabel)
    }
    
    override func setupLayout() {
        categoryImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
        }
        categoryLabel.do {
            $0.textAlignment = .left
        }
    }
}

extension CategoryCollectionViewCell {
    func bindData(_ data: GetCategoryFilterData) {
        categoryLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: data.name,
                color: .gray400
            )
        }
        categoryImageView.do {
            $0.setKFImage(url: data.imageUrl)
        }
    }
    
    func updateSelectedStyle() {
        backgroundColor = .hankkiRedLight
        layer.borderColor = UIColor.hankkiRed.cgColor
        categoryLabel.textColor = .gray700
    }
    
    func updateDefaultStyle() {
        backgroundColor = .hankkiWhite
        layer.borderColor = UIColor.gray200.cgColor
        categoryLabel.textColor = .gray400
    }
}
