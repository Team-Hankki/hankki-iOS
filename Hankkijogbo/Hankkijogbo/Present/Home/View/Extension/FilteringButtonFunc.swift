//
//  FilteringButtonFunc.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/15/24.
//

import UIKit

/// HomeViewController에서 extension을 통해 Filtering Button의 속성을 변경하는 함수들을 분리
extension HomeViewController {
    
    /// 필터링 선택 후 ButtonTitle 변경하는 함수
    func changeButtonTitle(for button: UIButton, newTitle: String) {
        button.do {
            $0.setTitle(newTitle, for: .normal)
            $0.backgroundColor = .red100
            $0.layer.borderColor = UIColor.red500.cgColor
            $0.setTitleColor(.red500, for: .normal)
            $0.setImage(.icClose.withTintColor(.red500), for: .normal)
            $0.removeTarget(self, action: nil, for: .touchUpInside)
            $0.addTarget(self, action: #selector(revertButtonAction(_:)), for: .touchUpInside)
            $0.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 3)
            
            if let leftImageView = button.viewWithTag(100) as? UIImageView {
                print("IMAGE가 있다요👾")
                print(leftImageView.image, "👾")
                leftImageView.isHidden = true
                leftImageView.layoutIfNeeded() 
            }
            
            $0.sizeToFit()
            $0.tag = 1
        }
    }
    
    /// close Button 클릭 시 다시 원래의 버튼으로 돌아오는 함수
    func revertButton(for button: UIButton, filter: String) {
        button.do {
            $0.applyDefaultStyle(title: filter)
            $0.removeTarget(self, action: nil, for: .touchUpInside)
            $0.contentEdgeInsets = .init(top: 0, left: 28, bottom: 0, right: 3)
            
            if let leftImageView = button.viewWithTag(100) as? UIImageView {
                leftImageView.isHidden = false
                leftImageView.layoutIfNeeded()
            }
            
            $0.sizeToFit()
            $0.tag = 0
        }
        
        if button == rootView.priceButton {
            button.addTarget(self, action: #selector(priceButtonDidTap), for: .touchUpInside)
        } else if button == rootView.sortButton {
            button.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(typeButtonDidTap), for: .touchUpInside)
        }
    }
    
    /// filtering이 되지 않았을 경우 원래의 버튼으로 돌아오는 함수
    func resetButtonToDefaultState(_ button: UIButton, defaultTitle: String) {
        if button.tag == 0 {
            button.applyDefaultStyle(title: defaultTitle)
        }
    }
    
    /// 필터링 Button을 재클릭 했을 경우 hide, show
    func toggleDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        if isTypeCollectionViewVisible {
            hideTypeCollectionView()
            isTypeCollectionViewVisible = false
        }
        
        if isDropDownVisible {
            hideDropDown(buttonType: currentDropDownButtonType) { [weak self] in
                self?.showDropDown(isPriceModel: isPriceModel, buttonType: buttonType)
                self?.currentDropDownButtonType = buttonType
                self?.isDropDownVisible = true
            }
        } else {
            showDropDown(isPriceModel: isPriceModel, buttonType: buttonType)
            currentDropDownButtonType = buttonType
            isDropDownVisible = true
        }
    }
    
    func toggleCollectionView() {
        if isDropDownVisible {
            hideDropDown(buttonType: currentDropDownButtonType) { [weak self] in
                self?.showTypeCollectionView()
                self?.isTypeCollectionViewVisible = true
                self?.isDropDownVisible = false
            }
        } else {
            if isTypeCollectionViewVisible {
                hideTypeCollectionView()
            } else {
                showTypeCollectionView()
            }
            isTypeCollectionViewVisible.toggle()
        }
    }
    
    /// DropDown을 button Type에 따라 표출하는 함수
    func showDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        if rootView.bottomSheetView.isBottomSheetUp {
            rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
        }
        
        customDropDown = DropDownView(isPriceModel: isPriceModel, buttonType: buttonType, viewModel: HomeViewModel())
        customDropDown?.delegate = self
        
        guard let customDropDown = customDropDown else { return }
        view.addSubview(customDropDown)
        customDropDown.snp.makeConstraints {
            $0.top.equalTo(isPriceModel ? rootView.priceButton.snp.bottom : rootView.sortButton.snp.bottom).offset(10)
            switch buttonType {
            case .price:
                rootView.priceButton.setTitleColor(.gray800, for: .normal)
                rootView.priceButton.setImage(.icArrowOpen, for: .normal)
                $0.centerX.equalTo(rootView.priceButton)
            case .sort:
                rootView.sortButton.setTitleColor(.gray800, for: .normal)
                rootView.sortButton.setImage(.icArrowOpen, for: .normal)
                $0.centerX.equalTo(rootView.sortButton)
            }
            $0.width.equalTo(112)
            $0.height.equalTo(0)
        }
        self.view.layoutIfNeeded()
        let height = isPriceModel ? self.viewModel.priceFilters.count * 44 : self.viewModel.sortOptions.count * 44
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            customDropDown.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    /// DropDown을 button Type에 따라 숨기는 함수
    func hideDropDown(buttonType: ButtonType? = nil, completion: (() -> Void)? = nil) {
        guard let customDropDown = customDropDown else {
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            customDropDown.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            customDropDown.removeFromSuperview()
            self.customDropDown = nil
            
            if let buttonType = buttonType {
                self.resetDropDownButtonIfNotChanged(buttonType: buttonType)
            }
            
            self.isDropDownVisible = false
            completion?()
        }
    }
    
    /// TypeCollectionView를 표출
    func showTypeCollectionView() {
        if rootView.bottomSheetView.isBottomSheetUp {
            rootView.bottomSheetView.viewLayoutIfNeededWithDownAnimation()
        }
        
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.typeCollectionView.collectionView.reloadData()
                }
            }
        }
        setupTypeCollectionView()
    }
    
    func setupTypeCollectionView() {
        typeCollectionView.isHidden = false
        view.addSubview(typeCollectionView)
        typeCollectionView.snp.makeConstraints {
            $0.top.equalTo(rootView.typeButton.snp.bottom).offset(8)
            $0.leading.equalTo(rootView).inset(8)
            $0.trailing.centerX.equalToSuperview()
        }
        rootView.typeButton.setTitleColor(.gray800, for: .normal)
        rootView.typeButton.setImage(.icArrowOpen, for: .normal)
    }
    
    /// TypeCollectionView를 숨김
    func hideTypeCollectionView() {
        typeCollectionView.isHidden = true
        resetTypeButtonIfNotChanged()
    }
    
    func resetDropDownButtonIfNotChanged(buttonType: ButtonType) {
        let button: UIButton
        let defaultTitle: String
        
        switch buttonType {
        case .price:
            button = rootView.priceButton
            defaultTitle = StringLiterals.Home.priceFilteringButton
        case .sort:
            button = rootView.sortButton
            defaultTitle = StringLiterals.Home.sortFilteringButton
        }
        
        if button.tag == 0 {
            button.applyDefaultStyle(title: defaultTitle)
        }
    }
    
    func resetTypeButtonIfNotChanged() {
        let button = rootView.typeButton
        let defaultTitle = StringLiterals.Home.storeCategoryFilteringButton
        
        if button.tag == 0 {
            button.applyDefaultStyle(title: defaultTitle)
        }
    }
}

extension HomeViewController {
    @objc func revertButtonAction(_ sender: UIButton) {
        let filter: String
        if sender == rootView.priceButton {
            filter = StringLiterals.Home.priceFilteringButton
            viewModel.priceCategory = ""
        } else if sender == rootView.sortButton {
            filter = StringLiterals.Home.sortFilteringButton
            viewModel.sortOption = ""
        } else {
            filter = StringLiterals.Home.storeCategoryFilteringButton
            viewModel.storeCategory = ""
        }
        revertButton(for: sender, filter: filter)
        viewModel.updateHankkiList()
    }
    
    @objc func priceButtonDidTap() {
        if isDropDownVisible && currentDropDownButtonType == .price {
            hideDropDown(buttonType: .price) {
                self.resetButtonToDefaultState(self.rootView.priceButton, defaultTitle: StringLiterals.Home.priceFilteringButton)
            }
        } else {
            toggleDropDown(isPriceModel: true, buttonType: .price)
        }
    }
    
    @objc func sortButtonDidTap() {
        if isDropDownVisible && currentDropDownButtonType == .sort {
            hideDropDown(buttonType: .sort) {
                self.resetButtonToDefaultState(self.rootView.sortButton, defaultTitle: StringLiterals.Home.sortFilteringButton)
            }
        } else {
            toggleDropDown(isPriceModel: false, buttonType: .sort)
        }
    }
    
    @objc func typeButtonDidTap() {
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.typeCollectionView.collectionView.reloadData()
                }
            }
        }
        toggleCollectionView()
    }
}

extension HomeViewController {
    func hideAllFiltering() {
        hideDropDown()
        typeCollectionView.isHidden = true
        resetButtonToDefaultState(rootView.priceButton, defaultTitle: StringLiterals.Home.priceFilteringButton)
        resetButtonToDefaultState(rootView.sortButton, defaultTitle: StringLiterals.Home.sortFilteringButton)
        resetButtonToDefaultState(rootView.typeButton, defaultTitle: StringLiterals.Home.storeCategoryFilteringButton)
    }
    
    func resetAllFilters() {
        resetDropDownButtonIfNotChanged(buttonType: .price)
        resetDropDownButtonIfNotChanged(buttonType: .sort)
        resetTypeButtonIfNotChanged()
        revertButton(for: rootView.priceButton, filter: StringLiterals.Home.priceFilteringButton)
        revertButton(for: rootView.sortButton, filter: StringLiterals.Home.sortFilteringButton)
        revertButton(for: rootView.typeButton, filter: StringLiterals.Home.storeCategoryFilteringButton)
        
        viewModel.updateHankkiList()
    }
}
