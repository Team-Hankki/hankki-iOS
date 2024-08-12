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
            $0.textAlignment = .left
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
        backgroundColor = .hankkiYellowLighten
        layer.borderColor = UIColor.hankkiDarkYellow.cgColor
        categoryLabel.font = .setupPretendardStyle(of: .body3)
        categoryLabel.textColor = .gray700
    }
    
    func updateDefaultStyle() {
        backgroundColor = .hankkiWhite
        layer.borderColor = UIColor.gray200.cgColor
        categoryLabel.font = .setupPretendardStyle(of: .body4)
        categoryLabel.textColor = .gray400
    }
}
