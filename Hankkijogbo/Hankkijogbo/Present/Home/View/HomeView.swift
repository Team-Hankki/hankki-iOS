//
//  HomeView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//
import UIKit
import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Properties
    
    private let buttonType = [StringLiterals.Home.storeCategoryFilteringButton,
                              StringLiterals.Home.priceFilteringButton,
                              StringLiterals.Home.sortFilteringButton]
    
    let leftImages: [UIImage] = [.imgFilteringEmpty,
                                 .imgFilteringCoin,
                                 .imgFilteringAlign]
    
    // MARK: - UI Components
    
    var mapView = NMFMapView()
    var bottomSheetView = TotalListBottomSheetView()
    
    let typeButton: UIButton = UIButton()
    let priceButton: UIButton = UIButton()
    let sortButton: UIButton = UIButton()
    
    private let buttonStackView: UIStackView = UIStackView()
    
    let targetButton: UIButton = UIButton()
    
    private let gradient: UIView = UIView()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(mapView,
                    gradient,
                    buttonStackView,
                    targetButton,
                    bottomSheetView)
        buttonStackView.addArrangedSubviews(typeButton,
                                            priceButton,
                                            sortButton)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.leading.equalTo(mapView).inset(12)
        }
        
        [typeButton, priceButton, sortButton].forEach { $0.snp.makeConstraints { $0.height.equalTo(32)} }
        
        targetButton.snp.makeConstraints {
            if bottomSheetView.isExpanded {
                targetButton.isHidden = true
            } else {
                $0.bottom.equalTo(bottomSheetView.snp.top).offset(-12)
                $0.trailing.equalToSuperview().inset(22)
                targetButton.isHidden = false
            }
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIScreen.getDeviceHeight() * 0.4)
        }
        
        gradient.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        let buttons = [typeButton, priceButton, sortButton]
        for (index, button) in buttons.enumerated() {
            let leftImageView = UIImageView(image: leftImages[index])
            leftImageView.tag = 100
            button.do {
                $0.backgroundColor = .hankkiWhite
                $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray300)
                $0.setTitle(buttonType[index], for: .normal)
                $0.setTitleColor(.gray500, for: .normal)
                $0.setImage(.icArrowClose.withTintColor(.gray500), for: .normal)
                $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
                $0.contentHorizontalAlignment = .left
                $0.semanticContentAttribute = .forceRightToLeft
                $0.contentEdgeInsets = .init(top: 0, left: 28, bottom: 0, right: 5)
            }
            
            button.addSubview(leftImageView)
            
            leftImageView.snp.makeConstraints {
                $0.leading.equalTo(button.snp.trailing).inset(24)
                $0.centerY.equalTo(button.snp.centerY)
                $0.width.height.equalTo(16)
            }
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.isUserInteractionEnabled = true
        }
        
        targetButton.do {
            $0.setImage(.btnTarget, for: .normal)
            
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 4
        }
        
        bottomSheetView.do {
            $0.backgroundColor = .clear
        }
        
        mapView.logoAlign = .rightTop
        
        gradient.do {
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.12
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 32
        }
    }
}

extension HomeView {
    
    func setupAddTarget() {
        let buttons = [typeButton, priceButton, sortButton]
        for button in buttons {
            button.addTarget(self, action: #selector(actionButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc func actionButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonStyle(sender)
    }
    
    func updateButtonStyle(_ button: UIButton) {
        if button.isSelected {
            button.setTitleColor(.gray600, for: .normal)
            button.setImage(.icArrowOpen.withTintColor(.black), for: .normal)
        } else {
            button.setTitleColor(.gray400, for: .normal)
            button.setImage(.icArrowClose, for: .normal)
        }
    }
}
