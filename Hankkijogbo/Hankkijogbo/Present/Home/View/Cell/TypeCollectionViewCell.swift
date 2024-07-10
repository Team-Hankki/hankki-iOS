//
//  TypeCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TypeCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = UIImageView()
    private let typeLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func setupHierarchy() {
        addSubviews(thumbnailImageView, typeLabel)
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(38)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    override func setupStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray200.cgColor
        self.makeRounded(radius: 16)
        self.backgroundColor = .white
        
        thumbnailImageView.do {
            $0.backgroundColor = .gray400
            $0.makeRounded(radius: 8)
        }
        
        typeLabel.do {
            $0.font = .setupPretendardStyle(of: .body3)
            $0.textColor = .gray400
        }
    }
}

extension TypeCollectionViewCell {
    func bindData(model: TypeModel) {
        typeLabel.text = model.menutype
    }
}
