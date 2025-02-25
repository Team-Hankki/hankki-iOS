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
    
    let thumbnailImageView: UIImageView = UIImageView()
    let typeLabel: UILabel = UILabel()
    private let selectedUnderLineView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    override func setupHierarchy() {
        addSubviews(thumbnailImageView, typeLabel, selectedUnderLineView)
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        selectedUnderLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.horizontalEdges.equalToSuperview().inset(2)
        }
    }
    
    override func setupStyle() {
        typeLabel.do {
            $0.font = .setupPretendardStyle(of: .caption1)
            $0.textColor = .gray900
        }
        
        selectedUnderLineView.do {
            $0.makeRoundBorder(cornerRadius: 2, borderWidth: 0, borderColor: .clear)
            $0.backgroundColor = .black
        }
    }
}

extension TypeCollectionViewCell {
    func bindData(model: GetCategoryFilterData) {
        typeLabel.text = model.name
        if let url = URL(string: model.imageUrl), !model.imageUrl.isEmpty {
            thumbnailImageView.setKFImage(url: model.imageUrl)
        } else {
            thumbnailImageView.image = .imgAll
        }
    }
    
    func updateSelection(isSelected: Bool) {
        selectedUnderLineView.isHidden = !isSelected
        typeLabel.font = .setupPretendardStyle(of: isSelected ? .caption3 : .caption1)
    }
}
