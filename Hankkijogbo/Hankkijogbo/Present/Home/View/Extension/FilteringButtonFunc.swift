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
        print("Changing button title to: \(newTitle)") // 디버깅 출력
        button.do {
            $0.setTitle(newTitle, for: .normal)
            $0.backgroundColor = .hankkiYellowLight
            $0.layer.borderColor = UIColor.hankkiYellow.cgColor
            $0.setImage(.icClose, for: .normal)
            $0.removeTarget(self, action: nil, for: .touchUpInside)
            $0.addTarget(self, action: #selector(revertButtonAction(_:)), for: .touchUpInside)
            $0.sizeToFit()
            $0.tag = 1 // 수정된 상태를 나타내기 위해 tag 값을 1로 설정
        }
    }
    
    @objc func revertButtonAction(_ sender: UIButton) {
        let filter: String
        if sender == rootView.priceButton {
            filter = "가격대"
        } else if sender == rootView.sortButton {
            filter = "정렬"
        } else {
            filter = "종류"
        }
        
        if sender.tag == 1 {
            revertButton(for: sender, filter: filter)
        }
    }
    
    /// close Button 클릭 시 다시 원래의 버튼으로 돌아오는 함수
    func revertButton(for button: UIButton, filter: String) {
        print("Reverting button title to: \(filter)") // 디버깅 출력
        button.do {
            $0.setTitle(filter, for: .normal)
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.setTitleColor(.gray400, for: .normal)
            $0.setImage(.icArrowClose, for: .normal)
            $0.removeTarget(self, action: nil, for: .touchUpInside)
            $0.sizeToFit()
            $0.tag = 0 // 원래 상태를 나타내기 위해 tag 값을 0으로 설정
        }
        
        if button == rootView.priceButton {
            button.addTarget(self, action: #selector(priceButtonDidTap), for: .touchUpInside)
        } else if button == rootView.sortButton {
            button.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(typeButtonDidTap), for: .touchUpInside)
        }
    }
    
    @objc func priceButtonDidTap() {
        toggleDropDown(isPriceModel: true, buttonType: .price)
    }
    
    @objc func sortButtonDidTap() {
        toggleDropDown(isPriceModel: false, buttonType: .sort)
    }
    
    @objc func typeButtonDidTap() {
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.typeCollectionView.collectionView.reloadData()
                }
            }
        }
        if isButtonModified {
            revertButton(for: rootView.typeButton, filter: "종류")
        } else {
            typeCollectionView.isHidden = false
            view.addSubview(typeCollectionView)
            typeCollectionView.snp.makeConstraints {
                $0.top.equalTo(rootView.typeButton.snp.bottom).offset(8)
                $0.leading.equalTo(rootView).inset(8)
                $0.trailing.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    /// DropDown을 button Type에 따라 표출하는 함수
    func showDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        customDropDown = DropDownView(isPriceModel: isPriceModel, buttonType: buttonType, viewModel: HomeViewModel())
        customDropDown?.delegate = self
        
        guard let customDropDown = customDropDown else { return }
        
        view.addSubview(customDropDown)
        
        customDropDown.snp.makeConstraints {
            $0.top.equalTo(isPriceModel ? rootView.priceButton.snp.bottom : rootView.sortButton.snp.bottom).offset(10)
            switch buttonType {
            case .price:
                $0.centerX.equalTo(rootView.priceButton)
            case .sort:
                $0.centerX.equalTo(rootView.sortButton)
            }
            $0.width.height.equalTo(0)
        }
        
        customDropDown.snp.updateConstraints {
            let height = isPriceModel ? self.viewModel.priceFilters.count * 44 : self.viewModel.sortOptions.count * 44
            $0.width.equalTo(112)
            $0.height.equalTo(height)
        }
        self.view.layoutIfNeeded() // 제약 조건을 즉시 적용하여 드롭다운을 바로 표시합니다.
    }
    
    func toggleDropDown(isPriceModel: Bool, buttonType: ButtonType) {
        if isDropDownVisible {
            hideDropDown()
        } else {
            showDropDown(isPriceModel: isPriceModel, buttonType: buttonType)
        }
        isDropDownVisible.toggle()
    }
    
    func hideDropDown() {
        guard let customDropDown = customDropDown else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            customDropDown.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            customDropDown.removeFromSuperview()
            self.customDropDown = nil
        }
    }
    
    func showTypeCollectionView() {
        viewModel.getCategoryFilterAPI { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.typeCollectionView.collectionView.reloadData()
                }
            }
        }
        typeCollectionView.isHidden = false
        view.addSubview(typeCollectionView)
        
        typeCollectionView.snp.makeConstraints {
            $0.top.equalTo(rootView.typeButton.snp.bottom).offset(8)
            $0.leading.equalTo(rootView).inset(8)
            $0.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
