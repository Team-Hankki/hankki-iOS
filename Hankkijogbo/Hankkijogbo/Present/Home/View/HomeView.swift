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
    let typeFiletringCollectionView = TypeCollectionView()
    var bottomSheetView = TotalListBottomSheetView()
    
    let typeButton: UIButton = UIButton()
    let priceButton: UIButton = UIButton()
    let sortButton: UIButton = UIButton()
    
    private let buttonStackView: UIStackView = UIStackView()
    
    let filteringFloatingButton: UIButton = UIButton()
    let targetButton: UIButton = UIButton()
    
    private let gradient: UIView = UIView()
    private let shadowView: UIView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientView()
    }
    
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(mapView,
                    gradient,
                    typeFiletringCollectionView,
                    shadowView,
                    filteringFloatingButton,
                    targetButton,
                    bottomSheetView)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeFiletringCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(typeFiletringCollectionView)
            $0.width.equalTo(64)
            $0.height.equalTo(54)
        }
        
        filteringFloatingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        targetButton.snp.makeConstraints {
            if bottomSheetView.isExpanded && bottomSheetView.isBottomSheetUp {
                targetButton.isHidden = true
            } else {
                $0.bottom.equalTo(bottomSheetView.snp.top).offset(-10)
                $0.trailing.equalToSuperview().inset(12)
                targetButton.isHidden = false
            }
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIScreen.getDeviceHeight() * 0.5)
        }
        
        gradient.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        filteringFloatingButton.do {
            $0.setImage(.icFilteringNormal, for: .normal)
            $0.setImage(.icFilteringSelected, for: .selected)
            $0.clipsToBounds = false
            superview?.clipsToBounds = false
        }
        
        shadowView.do {
            $0.backgroundColor = .clear
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
    
    func setupGradientView() {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.hankkiWhite.withAlphaComponent(0).cgColor,
                UIColor.hankkiWhite.cgColor
            ]
            $0.locations = [0.0, 1.0]
            $0.startPoint = CGPoint(x: 0.0, y: 0.5)
            $0.endPoint = CGPoint(x: 1.0, y: 0.5)
            $0.frame = self.shadowView.bounds
        }
        self.shadowView.layer.addSublayer(gradient)
    }

}
