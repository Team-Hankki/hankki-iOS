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
    private let menutagLabel: UILabel = UILabel()
    private let hankkiTitle: UILabel = UILabel()
    
    private let lowestPriceLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let likeImage: UIImageView = UIImageView()
    private let likeLabel: UILabel = UILabel()
    
    private let hankkiInfoStackView: UIStackView = UIStackView()
    private let hankkiDetailStackView: UIStackView = UIStackView()
    private let hankkiLowPriceStackView: UIStackView = UIStackView()
    
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
                    hankkiInfoStackView,
                    addButton)
        
        hankkiInfoStackView.addArrangedSubviews(menutagLabel,
                                                hankkiDetailStackView,
                                                hankkiLowPriceStackView)
        
        hankkiDetailStackView.addArrangedSubviews(hankkiTitle,
                                                  likeImage,
                                                  likeLabel)
        
        hankkiLowPriceStackView.addArrangedSubviews(lowestPriceLabel, priceLabel)
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
            $0.font = .setupPretendardStyle(of: .caption4)
            $0.textColor = .gray500
        }
        
        hankkiTitle.do {
            $0.textColor = .gray850
            $0.font = .setupPretendardStyle(of: .body5)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        
        likeLabel.do {
            $0.font = .setupPretendardStyle(of: .caption1)
            $0.textColor = .gray700
        }
        
        priceLabel.do {
            $0.font = .setupPretendardStyle(of: .body6)
            $0.textColor = .gray800
        }
        
        lowestPriceLabel.do {
            $0.text = StringLiterals.Home.lowest
            $0.font = .setupPretendardStyle(of: .caption4)
            $0.textColor = .gray400
        }
        
        likeImage.do {
            $0.image = .icHeartRed
        }
        
        hankkiInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.alignment = .leading
        }
        
        hankkiDetailStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.alignment = .center
        }
        
        hankkiLowPriceStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        
        addButton.do {
            $0.setImage(.icAddZipGray, for: .normal)
        }
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(72)
        }
        
        hankkiInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(thumbnailImageView)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(22)
        }
    }
}

// MARK: - Network

extension TotalListCollectionViewCell {
    func bindData(model: GetHankkiListData) {
        thumbnailImageView.setKFImage(url: model.imageUrl, placeholder: .imgDetailDefault)
        menutagLabel.text = model.category
        hankkiTitle.text = model.name
        priceLabel.formattingPrice(price: model.lowestPrice)
        likeLabel.text = String(model.heartCount)
    }
}
