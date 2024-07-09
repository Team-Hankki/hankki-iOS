//
//  ZipListCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class ZipListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var data: DataStruct?
    private var isEditMode: Bool = false
    
    // MARK: - UI Properties
    
    private let cellView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    private let selectButton: UIImageView = UIImageView()
    private let redOpacityLayerView: UIView = UIView()
    
    override func setupStyle() {
        cellView.do {
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 12
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "test",
                color: .hankkiWhite
            )
            $0.numberOfLines = 3
            $0.textAlignment = .left
            $0.lineBreakMode = .byTruncatingTail
        }
        
        imageView.do {
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 2
        }
        
        selectButton.do {
            $0.backgroundColor = .gray400
            $0.isHidden = true
        }
        
        redOpacityLayerView.do {
            $0.backgroundColor = .hankkiRed.withAlphaComponent(0.4)
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.hankkiRed.cgColor
            $0.layer.borderWidth = 2
            
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
            $0.height.equalTo(UIView.convertByAspectRatioHeight(self.frame.width, width: 160, height: 160))
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
    struct DataStruct {
        let title: String
        var type: CellType = .common
    }
    
    enum CellType {
        case create
        case common
        
        var backgroundColor: UIColor {
            switch self {
            case .create:
                .hankkiYellow
            case .common:
                .gray800
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .create:
                .gray800
            case .common:
                .white
            }
        }
    }
    
    func dataBind(_ data: DataStruct) {
        self.data = data
        titleLabel.text = self.data?.title
        
        titleLabel.attributedText = UILabel.setupAttributedText(
            for: PretendardStyle.subtitle3,
            withText: data.title,
            color: data.type.fontColor
        )
    }
    
    func setSelected(_ selected: Bool) {
        selectButton.isHidden = !selected
        redOpacityLayerView.isHidden = !selected
    }
}
