//
//  CategoryCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    let categoryImageView: UIImageView = UIImageView()
    let categoryLabel: UILabel = UILabel()
    
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
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                color: .gray400
            )
            $0.textAlignment = .left
        }
        categoryImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
}

extension CategoryCollectionViewCell {
    func bindData(_ data: HankkiCategoryModel) {
        categoryLabel.text = data.categoryData.name
        categoryImageView.setKFImage(url: data.categoryData.imageUrl)
        
        if data.isChecked {
            updateSelectedStyle()
        } else {
            updateDefaultStyle()
        }
    }
    
    func updateSelectedStyle() {
        backgroundColor = .yellow300
        layer.borderColor = UIColor.yellow500.cgColor
        categoryLabel.font = UIFont.setupPretendardStyle(of: .body5)
        categoryLabel.textColor = .gray700
    }
    
    func updateDefaultStyle() {
        backgroundColor = .hankkiWhite
        layer.borderColor = UIColor.gray200.cgColor
        categoryLabel.font = .setupPretendardStyle(of: .body6)
        categoryLabel.textColor = .gray400
    }
}
