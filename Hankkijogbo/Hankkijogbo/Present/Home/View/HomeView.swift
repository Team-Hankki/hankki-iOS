//
//  HomeView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//
import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Properties
    
    private let buttonType = [StringLiterals.Home.storeCategoryFilteringButton,
                              StringLiterals.Home.priceFilteringButton,
                              StringLiterals.Home.sortFilteringButton]
    
    // MARK: - UI Components
    
    var mapView = NMFMapView()
    var bottomSheetView = TotalListBottomSheetView()
    
    let typeButton = UIButton()
    let priceButton = UIButton()
    let sortButton = UIButton()
    
    private let buttonStackView = UIStackView()
    
    let targetButton = UIButton()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(mapView,
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
                $0.trailing.equalToSuperview().inset(12)
            }
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIScreen.getDeviceHeight() * 0.4)
        }
    }
    
    override func setupStyle() {
        let buttons = [typeButton, priceButton, sortButton]
        for (index, button) in buttons.enumerated() {
            button.do {
                $0.backgroundColor = .white
                $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray300)
                $0.setTitle(buttonType[index], for: .normal)
                $0.setTitleColor(.gray400, for: .normal)
                $0.setImage(.icArrowClose, for: .normal)
                $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
                $0.contentHorizontalAlignment = .left
                $0.semanticContentAttribute = .forceRightToLeft
                $0.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
            }
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        targetButton.do {
            $0.setImage(.btnTarget, for: .normal)
        }
        
        bottomSheetView.do {
            $0.backgroundColor = .clear
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
