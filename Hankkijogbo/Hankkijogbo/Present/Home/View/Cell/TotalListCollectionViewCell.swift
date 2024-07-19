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
    private let menutag: UILabel = UILabel()
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
                    menutag,
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
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        menutag.do {
            $0.makeRounded(radius: 10)
            $0.backgroundColor = .hankkiRedLight
            $0.textColor = .hankkiRed
            $0.font = .setupPretendardStyle(of: .caption2)
            $0.textAlignment = .center
        }
        
        hankkiTitle.do {
            $0.textColor = .gray900
            $0.font = .setupSuiteStyle(of: .subtitle)
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
            $0.verticalEdges.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(72)
        }
        
        menutag.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.width.equalTo(42)
            $0.height.equalTo(20)
        }
        
        hankkiTitle.snp.makeConstraints {
            $0.top.equalTo(menutag.snp.bottom).offset(4)
            $0.leading.equalTo(menutag.snp.leading)
        }
        
        hankkiInfoStackView.snp.makeConstraints {
            $0.top.equalTo(hankkiTitle.snp.bottom).offset(2)
            $0.leading.equalTo(menutag.snp.leading)
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
        thumbnailImageView.setKFImage(url: model.imageUrl)
        menutag.text = model.category
        hankkiTitle.text = model.name
        priceLabel.text = String(model.lowestPrice) + "원"
        likeLabel.text = String(model.heartCount)
    }
}
