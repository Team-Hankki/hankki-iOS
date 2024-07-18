//
//  MyZipListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

final class MyZipListCollectionViewCell: BaseCollectionViewCell {
    
    var isChecked: Bool = false
    // TODO: - literal로 빼기
    var updateStringNotificationName: String = "UpdateAddToMyZipListString"
    
    // MARK: - UI Components
    
    private let thumbnailImageView = UIImageView()
    private let zipTitleLabel = UILabel()
    private let firstHashtagLabel = UILabel()
    private let secondHashtagLabel = UILabel()
    let addZipButton = UIButton()
    
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
            $0.trailing.equalToSuperview().inset(37)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    override func setupStyle() {
        thumbnailImageView.do {
            $0.layer.cornerRadius = 10
        }
        zipTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: "학교 5년째 다니는 화석의 추천",
                color: .gray800
            )
        }
        firstHashtagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "#미친가성비",
                color: .gray400
            )
        }
        addZipButton.do {
            $0.setImage(.btnAddLined, for: .normal)
            $0.addTarget(self, action: #selector(addZipButtonDidTap), for: .touchUpInside)
        }
    }
}

extension MyZipListCollectionViewCell {

    func getImageForType(_ type: String) -> UIImage {
        let thumbnailImages: [String: UIImage] = [
            "TYPE_ONE": .imgZipThumbnail1,
            "TYPE_TWO": .imgZipThumbnail2,
            "TYPE_THREE": .imgZipThumbnail3,
            "TYPE_FOUR": .imgZipThumbnail4
        ]
        
        return thumbnailImages[type] ?? .imgZipThumbnail1
    }
    
    func setupLabelStyleOfData(zipData: GetMyZipFavorite) {
        zipTitleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body2,
                withText: zipData.title,
                color: .gray800
            )
        }
        firstHashtagLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: zipData.details[0],
                color: .gray400
            )
        }
        
        if zipData.details.count > 1 {
            secondHashtagLabel.do {
                $0.attributedText = UILabel.setupAttributedText(
                    for: PretendardStyle.button,
                    withText: zipData.details[1],
                    color: .gray400
                )
            }
        }
    }
    
    func bindData(zipData: GetMyZipFavorite) {
        isChecked = zipData.isAdded
        thumbnailImageView.image = getImageForType(zipData.imageType)
        setupLabelStyleOfData(zipData: zipData)
    }
    
    @objc func addZipButtonDidTap() {
        isChecked = !isChecked
        if isChecked {
            addZipButton.setImage(.btnCheckFilled, for: .normal)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(updateStringNotificationName)))
        } else {
            addZipButton.setImage(.btnAddLined, for: .normal)
        }
    }
}
