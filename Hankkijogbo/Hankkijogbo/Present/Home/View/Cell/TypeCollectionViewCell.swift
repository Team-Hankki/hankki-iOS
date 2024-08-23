//
//  TypeCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TypeCollectionViewCell: BaseCollectionViewCell {
    
    private let viewModel = HomeViewModel()
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = UIImageView()
    private let typeLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func setupHierarchy() {
        addSubviews(thumbnailImageView, typeLabel)
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray200)
            $0.backgroundColor = .white
        }
        
        thumbnailImageView.do {
            $0.makeRoundBorder(cornerRadius: 8, borderWidth: 0, borderColor: .clear)
        }
        
        typeLabel.do {
            $0.font = .setupPretendardStyle(of: .body4)
            $0.textColor = .gray400
        }
    }
}

extension TypeCollectionViewCell {
    func bindData(model: GetCategoryFilterData) {
        typeLabel.text = model.name
        thumbnailImageView.setKFImage(url: model.imageUrl)
    }
}
