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
    
    override func setupHierarchy() {
        addSubviews(thumbnailImageView, typeLabel)
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.horizontalEdges.equalToSuperview().inset(31)
            $0.width.height.equalTo(38)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    override func setupStyle() {
        thumbnailImageView.do {
            $0.backgroundColor = .gray600
            $0.makeRounded(radius: 8)
        }
        
        typeLabel.do {
            $0.font = .setupPretendardStyle(of: .body3)
            $0.textColor = .gray400
        }
    }
}

extension TypeCollectionViewCell {
    func bindData() {
        let typeList = ["한식", "중식", "양식", "일식", "분식"]
        for type in typeList {
            typeLabel.text = type
        }
    }
}
