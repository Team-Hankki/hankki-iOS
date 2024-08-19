//
//  TotalListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/9/24.
//

import UIKit

final class TotalListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Components
    
    let thumbnailImageView: UIImageView = UIImageView()
    private let menutagLabel: UILabel = HankkiCategoryTagLabel()
    private let hankkiTitle: UILabel = UILabel()
    
    private let priceImage: UIImageView = UIImageView()
    private let priceLabel: UILabel = UILabel()
    private let dotImage: UIImageView = UIImageView()
    private let likeImage: UIImageView = UIImageView()
    private let likeLabel: UILabel = UILabel()
    
    private let hankkiInfoStackView: UIStackView = UIStackView()
    
    let addButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(thumbnailImageView,
                    menutagLabel,
                    hankkiTitle,
                    hankkiInfoStackView,
                    addButton)
        
        hankkiInfoStackView.addArrangedSubviews(priceImage,
                                                priceLabel, 
                                                dotImage, 
                                                likeImage,
                                                likeLabel)
    }
    
    override func setupStyle() {
        backgroundColor = .white
        
        thumbnailImageView.do {
            $0.makeRoundBorder(cornerRadius: 8, borderWidth: 0, borderColor: .clear)
            $0.contentMode = .scaleAspectFill
        }
        
        menutagLabel.do {
            $0.setNeedsLayout()
            $0.layoutIfNeeded()
        }
        
        hankkiTitle.do {
            $0.textColor = .gray900
            $0.font = .setupSuiteStyle(of: .subtitle2)
        }
        
        [priceLabel, likeLabel].forEach {
            $0.do {
                $0.font = .setupPretendardStyle(of: .button)
                $0.textColor = .gray500
            }
        }
        
        priceImage.do {
            $0.image = .icFood16
        }
        
        dotImage.do {
            $0.image = .icSeparator
        }
        
        likeImage.do {
            $0.image = .icHeart
        }
            
        hankkiInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        
        addButton.do {
            $0.setImage(.btnAddFilled, for: .normal)
        }
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(72)
        }
        
        menutagLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.height.equalTo(20)
        }
        
        hankkiTitle.snp.makeConstraints {
            $0.top.equalTo(menutagLabel.snp.bottom).offset(4)
            $0.leading.equalTo(menutagLabel.snp.leading)
        }
        
        hankkiInfoStackView.snp.makeConstraints {
            $0.top.equalTo(hankkiTitle.snp.bottom).offset(2)
            $0.leading.equalTo(menutagLabel.snp.leading)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Network

extension TotalListCollectionViewCell {
    func bindData(model: GetHankkiListData) {
        thumbnailImageView.setKFImage(url: model.imageUrl, placeholder: .imgDetailDefault)
        menutagLabel.text = model.category
        hankkiTitle.text = model.name
        priceLabel.text = String(model.lowestPrice) + StringLiterals.Common.won
        likeLabel.text = String(model.heartCount)
    }
}
