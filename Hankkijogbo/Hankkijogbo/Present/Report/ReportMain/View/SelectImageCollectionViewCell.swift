//
//  SelectImageCollectionViewCell.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class SelectImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let recommendGuideLabel: UILabel = UILabel()
    let selectImageButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCustomLayer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        contentView.addSubviews(recommendGuideLabel, selectImageButton)
    }
    
    override func setupLayout() {
        recommendGuideLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        selectImageButton.snp.makeConstraints {
            $0.top.equalTo(recommendGuideLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
    }
    
    override func setupStyle() {
        recommendGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: StringLiterals.Report.addMenuSubtitle,
                color: .gray400
            )
        }
        selectImageButton.do {
            $0.backgroundColor = .gray100
            $0.makeRoundBorder(cornerRadius: 10, borderWidth: 0, borderColor: .clear)
            $0.setImage(.icAddPhoto, for: .normal)
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.body5,
                withText: StringLiterals.Report.addImage,
                color: .gray500
            ), for: .normal)
            $0.configuration = .plain()
            $0.configuration?.titleAlignment = .center
            $0.configuration?.imagePadding = 6
        }
    }
}

private extension SelectImageCollectionViewCell {
    func setupCustomLayer() {
        selectImageButton.layoutIfNeeded()
     
        let customLayer = CAShapeLayer()
        let frameSize = selectImageButton.bounds.size
        let shapeRect = CGRect(x: 0,
                               y: 0,
                               width: frameSize.width,
                               height: frameSize.height)
        
        customLayer.bounds = shapeRect
        customLayer.position = CGPoint(x: frameSize.width / 2,
                                       y: frameSize.height / 2)
        customLayer.fillColor = UIColor.clear.cgColor
        customLayer.strokeColor = UIColor.gray200.cgColor
        customLayer.lineWidth = 2
        customLayer.lineJoin = CAShapeLayerLineJoin.round
        customLayer.lineDashPattern = [4, 4]
        customLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        selectImageButton.layer.sublayers?.removeAll { $0 is CAShapeLayer }
        selectImageButton.layer.addSublayer(customLayer)
    }
}
