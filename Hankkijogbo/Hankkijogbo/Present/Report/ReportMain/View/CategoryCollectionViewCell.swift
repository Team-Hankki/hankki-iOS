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
    
    var selectedCategoryString: String? {
        didSet {
            print(selectedCategoryString ?? "")
        }
    }
    var data: GetCategoryFilterData?
    
    weak var delegate: PassItemDataDelegate?
    
    override var isSelected: Bool {
        didSet {
            self.do {
                if isSelected {
                    if selectedCategoryString != nil {
                        delegate?.updateViewModelCategoryData(data: nil)
                        updateDefaultStyle()
                        $0.selectedCategoryString = nil
                    } else {
                        delegate?.updateViewModelCategoryData(data: data)
                        updateSelectedStyle()
                        $0.selectedCategoryString = self.categoryLabel.text
                    }
                } else {
                    delegate?.updateViewModelCategoryData(data: nil)
                    updateDefaultStyle()
                    $0.selectedCategoryString = nil
                }
            }
        }
    }
    
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
                for: PretendardStyle.body4,
                color: .gray400
            )
            $0.textAlignment = .left
        }
    }
}

extension CategoryCollectionViewCell {
    func bindData(_ data: GetCategoryFilterData) {
        categoryLabel.text = data.name
        categoryImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.setKFImage(url: data.imageUrl)
        }
        self.data = data
    }
    
    func updateSelectedStyle() {
        backgroundColor = .hankkiYellowLighten
        layer.borderColor = UIColor.hankkiDarkYellow.cgColor
        categoryLabel.font = UIFont.setupPretendardStyle(of: .body3)
        categoryLabel.textColor = .gray700
    }
    
    func updateDefaultStyle() {
        backgroundColor = .hankkiWhite
        layer.borderColor = UIColor.gray200.cgColor
        categoryLabel.font = UIFont.setupPretendardStyle(of: .body4)
        categoryLabel.textColor = .gray400
    }
}
