//
//  CategoryCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Components
    
    private let categoryButton = UIButton()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        contentView.addSubview(categoryButton)
    }
    
    override func setupLayout() {
        categoryButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        categoryButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.setImage(.icHeart, for: .normal)
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 10)
            $0.configuration?.imagePadding = 2
        }
    }
}

extension CategoryCollectionViewCell {
    func dataBind(_ text: String) {
        categoryButton.setAttributedTitle(UILabel.setupAttributedText(
            for: PretendardStyle.body4,
            withText: text,
            color: .gray400
        ), for: .normal)
    }
}
