//
//  ZipListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class ZipListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var model: Model?
    
    // MARK: - UI Properties
    
    private let cellView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    private let selectButton: UIImageView = UIImageView()
    private let redOpacityLayerView: UIView = UIView()
    
    override func setupStyle() {
        cellView.do {
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 0, borderColor: .clear)
        }
        
        titleLabel.do {
            $0.numberOfLines = 3
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
        }
        
        selectButton.do {
            $0.image = .btnCheckFilled
            $0.isHidden = true
        }
        
        redOpacityLayerView.do {
            $0.backgroundColor = .red500.withAlphaComponent(0.4)
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 2, borderColor: .red500)
            $0.isHidden = true
        }
    }
    
    override func setupHierarchy() {
        self.addSubview(cellView)
        cellView.addSubviews(titleLabel,
                             imageView,
                             redOpacityLayerView,
                             selectButton)
    }
    
    override func setupLayout() {
        cellView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.width.equalTo(110)
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(UIView.convertByAspectRatioHeight(self.frame.width, width: 160, height: 137))
            $0.bottom.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(12)
        }
        
        redOpacityLayerView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
}

extension ZipListCollectionViewCell {
    func dataBind(_ model: Model) {
        self.model = model
        
        cellView.backgroundColor = model.type.backgroundColor
        titleLabel.attributedText = UILabel.setupAttributedText(
            for: PretendardStyle.subtitle3,
            withText: model.title,
            color: model.type.fontColor
        )

        if model.type == .common {
            if let imageType = ImageType(from: model.imageUrl) {
                imageView.image = model.type.image(for: imageType)
            }
        } else {
            imageView.image = model.type.image(for: nil)
        }

    }
    
    func setSelected(_ selected: Bool) {
        selectButton.isHidden = !selected
        redOpacityLayerView.isHidden = !selected
    }
}
