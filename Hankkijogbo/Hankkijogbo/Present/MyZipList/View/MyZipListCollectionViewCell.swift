//
//  MyZipListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

final class MyZipListCollectionViewCell: BaseCollectionViewCell {
    
    var isChecked: Bool = false
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = UIImageView()
    private let zipTitleLabel: UILabel = UILabel()
    private let firstHashtagLabel: UILabel = UILabel()
    private let secondHashtagLabel: UILabel = UILabel()
    let addZipButton: UIButton = UIButton()
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        contentView.addSubviews(
            thumbnailImageView,
            zipTitleLabel,
            firstHashtagLabel,
            secondHashtagLabel,
            addZipButton
        )
    }
    
    override func setupLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.top.equalToSuperview().inset(6)
            $0.width.height.equalTo(56)
        }
        zipTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(thumbnailImageView).offset(5.5)
        }
        firstHashtagLabel.snp.makeConstraints {
            $0.leading.equalTo(zipTitleLabel)
            $0.top.equalTo(zipTitleLabel.snp.bottom).offset(6)
        }
        secondHashtagLabel.snp.makeConstraints {
            $0.leading.equalTo(firstHashtagLabel.snp.trailing).offset(4)
            $0.top.equalTo(firstHashtagLabel)
        }
        addZipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    override func setupStyle() {
        thumbnailImageView.do {
            $0.layer.cornerRadius = 10
        }
        addZipButton.do {
            $0.setImage(.btnAddLined, for: .normal)
        }
    }
}

extension MyZipListCollectionViewCell {

    func getImageForType(_ type: String) -> UIImage {
        let thumbnailImages: [String: UIImage] = [
            StringLiterals.MyZip.zipThumbnailImageType1: .imgMyZip1,
            StringLiterals.MyZip.zipThumbnailImageType2: .imgMyZip2,
            StringLiterals.MyZip.zipThumbnailImageType3: .imgMyZip3,
            StringLiterals.MyZip.zipThumbnailImageType4: .imgMyZip4
        ]
        
        return thumbnailImages[type] ?? .imgMyZip1
    }
    
    func setupLabelStyleOfData(zipData: GetMyZipFavorite) {
        zipTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body3,
                withText: zipData.title,
                color: isChecked ? .gray200 : .gray800
            )
        }
        firstHashtagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: zipData.details[0],
                color: isChecked ? .gray200 : .gray400
            )
        }
        
        if zipData.details.count > 1 {
            secondHashtagLabel.do {
                $0.attributedText = UILabel.setupAttributedText(
                    for: PretendardStyle.button,
                    withText: zipData.details[1],
                    color: isChecked ? .gray200 : .gray400
                )
            }
        }
    }
    
    func bindData(zipData: GetMyZipFavorite) {
        isChecked = zipData.isAdded
        addZipButton.isUserInteractionEnabled = !isChecked
        addZipButton.setImage(isChecked ? .btnAddLinedDisabled : .btnAddLined, for: .normal)
        thumbnailImageView.image = getImageForType(zipData.imageType)
        thumbnailImageView.alpha = isChecked ? 0.3 : 1.0
        setupLabelStyleOfData(zipData: zipData)
    }
}
