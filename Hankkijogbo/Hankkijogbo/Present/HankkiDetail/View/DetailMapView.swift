//
//  DetailMapView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/24/24.
//

import UIKit

import NMapsMap

final class DetailMapView: BaseView {
    
    // MARK: - Properties
    // MARK: - UI Components
    
    private let mapView: NMFMapView = NMFMapView()
    private let addressView: UIView = UIView()
    private let addressGuideLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let copyButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(mapView, addressView)
        
        addressView.addSubviews(
            addressGuideLabel,
            addressLabel,
            copyButton
        )
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(180)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(mapView)
            $0.height.equalTo(41)
        }
        
        addressGuideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(addressGuideLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(addressGuideLabel)
        }
        
        copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(addressLabel)
            $0.width.equalTo(36)
            $0.height.equalTo(25)
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        mapView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 1, borderColor: .imageLine)
        }
        
        addressView.do {
            $0.backgroundColor = .hankkiWhite
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 1, borderColor: .imageLine)
        }
        
        addressGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption4,
                withText: "주소",
                color: .gray400
            )
        }
        
        addressLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption4,
                withText: "경기도 수원시 아주대학교 어쩌구",
                color: .gray700
            )
        }
        
        copyButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 6
            
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.caption5,
                withText: "복사",
                color: .gray600
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    // MARK: - Private Func
    // MARK: - @objc Func
    
}
