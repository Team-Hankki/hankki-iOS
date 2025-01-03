//
//  DetailMapView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/24/24.
//

import UIKit

import NMapsMap

final class DetailMapView: BaseView {
    
    // MARK: - UI Components
    
    private let mapView: NMFMapView = NMFMapView()
    private let addressView: UIView = UIView()
    private let addressGuideLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let copyButton: UIButton = UIButton()
    
    private let mapErrorView: UIView = UIView()
    private let mapErrorLabel: UILabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        addSubviews(addressView, mapView)
        
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
            $0.top.equalToSuperview().inset(11.5)
        }
        
        copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(addressLabel)
            $0.width.equalTo(36)
            $0.height.equalTo(25)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(addressGuideLabel.snp.trailing).offset(8)
            $0.trailing.equalTo(copyButton.snp.leading).offset(-6)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        self.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        mapView.do {
            $0.zoomLevel = 16
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.makeRoundBorder(cornerRadius: 8, borderWidth: 1, borderColor: .imageLine)
        }
        
        addressView.do {
            $0.backgroundColor = .hankkiWhite
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            $0.makeRoundBorder(cornerRadius: 12, borderWidth: 1, borderColor: .gray200)
        }
        
        addressGuideLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption4,
                withText: StringLiterals.HankkiDetail.address,
                color: .gray400
            )
        }
        
        addressLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption4,
                color: .gray700
            )
            $0.numberOfLines = 2
        }
        
        copyButton.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 6
            
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.caption5,
                withText: StringLiterals.HankkiDetail.copy,
                color: .gray600
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
        
        mapErrorView.do {
            $0.backgroundColor = .gray100
            $0.makeRoundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 8)
            $0.makeRoundBorder(cornerRadius: 8, borderWidth: 1, borderColor: .imageLine)
        }
        
        mapErrorLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.caption4,
                withText: StringLiterals.HankkiDetail.mapLoadErrorMessage,
                color: .gray400
            )
        }
    }
}

extension DetailMapView {
    
    func bindData(latitude: Double, longitude: Double, address: String) {
        addressLabel.text = address
        
        updateAddressViewLayout()
        addMapMarker(latitude: latitude, longitude: longitude)
        moveMapCamera(latitude: latitude, longitude: longitude)
    }
    
    func handleMapLoadError() {
        showMapErrorView()
        disableCopyButton()
    }
}

// MARK: - Private Func

private extension DetailMapView {
    
    func setupAddTarget() {
        copyButton.addTarget(self, action: #selector(copyButtonDidTap), for: .touchUpInside)
    }
    
    func updateAddressViewLayout() {
        let maxSize: CGSize = CGSize(width: addressLabel.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize: CGSize = addressLabel.sizeThatFits(maxSize)
        let spacing: CGFloat = expectedSize.height > 18 ? 8 : 11.5 // 줄 수를 기준으로
        
        addressView.snp.updateConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(-1)
            $0.leading.trailing.equalTo(mapView)
            $0.height.equalTo(spacing + expectedSize.height + spacing)
        }
        
        addressGuideLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(spacing)
        }
    }
    
    func copyAddressToClipboard() {
        UIPasteboard.general.string = addressLabel.text
    }
    
    func addMapMarker(latitude: Double, longitude: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: latitude, lng: longitude)
        marker.iconImage = NMFOverlayImage(image: .icPin)
        marker.mapView = mapView
    }
    
    func moveMapCamera(latitude: Double, longitude: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        mapView.moveCamera(cameraUpdate)
    }
    
    func showMapErrorView() {
        addSubview(mapErrorView)
        mapErrorView.addSubview(mapErrorLabel)
        
        mapErrorView.snp.makeConstraints {
            $0.edges.equalTo(mapView)
        }
        
        mapErrorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func disableCopyButton() {
        copyButton.isEnabled = false
        
        if let attributedTitle = UILabel.setupAttributedText(
            for: PretendardStyle.caption5,
            withText: StringLiterals.HankkiDetail.copy,
            color: .gray300
        ) {
            copyButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    
    // MARK: - @objc Func
    
    @objc func copyButtonDidTap() {
        copyAddressToClipboard()
        UIApplication.showBlackToast(message: StringLiterals.HankkiDetail.copyToastMessage)
    }
}
