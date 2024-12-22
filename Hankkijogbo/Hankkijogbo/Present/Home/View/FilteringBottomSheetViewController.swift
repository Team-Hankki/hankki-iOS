//
//  FilteringBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 12/13/24.
//

import UIKit

final class FilteringBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var defaultHeight: CGFloat = 266
    private let viewModel = HomeViewModel()
    
    private let filteringTitleList = [StringLiterals.Home.priceFilteringButton, StringLiterals.Home.sortFilteringButton]
    private var priceData: [GetPriceFilterData] = []
    private var sortData: [GetSortOptionFilterData] = []
    
    // MARK: - Components
    
    private let dimmedView: UIView = UIView()
    private let containerView: UIView = UIView()
    
    private let priceTitleLabel: UILabel = UILabel()
    private let entireChipButton: UIButton = UIButton()
    private let less6000ChipButton: UIButton = UIButton()
    private let more6000ChipButton: UIButton = UIButton()
    private let priceChipStackView: UIStackView = UIStackView()
    
    private let sortTitleLabel: UILabel = UILabel()
    private let latestChipButton: UIButton = UIButton()
    private let lowestChipButton: UIButton = UIButton()
    private let recommendChipButton: UIButton = UIButton()
    private let sortChipStackView: UIStackView = UIStackView()
    
    private let applyButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
        bindViewModels()
    }
    
    override func setupHierarchy() {
        view.addSubviews(dimmedView, containerView)
        
        containerView.addSubviews(
            priceTitleLabel,
            priceChipStackView,
            sortTitleLabel,
            sortChipStackView,
            applyButton
        )
        
        priceChipStackView.addArrangedSubviews(entireChipButton, less6000ChipButton, more6000ChipButton)
        sortChipStackView.addArrangedSubviews(latestChipButton, lowestChipButton, recommendChipButton)
    }
    
    override func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
        
        priceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(22)
        }
        
        priceChipStackView.snp.makeConstraints {
            $0.top.equalTo(priceTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(22)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.top.equalTo(priceChipStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(22)
        }
        
        sortChipStackView.snp.makeConstraints {
            $0.top.equalTo(sortTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(22)
        }
        
        applyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(68)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        [entireChipButton, less6000ChipButton, more6000ChipButton, latestChipButton, lowestChipButton, recommendChipButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(30)
            }
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .clear
        }
        
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.67)
        }
        
        containerView.do {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 18
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        [priceTitleLabel, sortTitleLabel].enumerated().forEach { index, label in
            label.do {
                $0.font = .setupPretendardStyle(of: .body4)
                $0.textColor = .gray850
                $0.text = filteringTitleList[index]
            }
        }
        
        [entireChipButton, less6000ChipButton, more6000ChipButton, latestChipButton, lowestChipButton, recommendChipButton].forEach {
            defaultButtonStyle(button: $0)
        }
        
        [priceChipStackView, sortChipStackView].forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.isUserInteractionEnabled = true
            }
        }
        
        applyButton.do {
            $0.setTitle(StringLiterals.Home.apply, for: .normal)
            $0.titleLabel?.font = .setupPretendardStyle(of: .body4)
            $0.setTitleColor(.gray800, for: .normal)
            $0.backgroundColor = .hankkiWhite
            $0.isEnabled = true
        }
    }
}


private extension FilteringBottomSheetViewController {
    func defaultButtonStyle(button: UIButton) {
        button.do {
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray300)
            $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
            $0.setTitleColor(.gray600, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            $0.sizeToFit()
        }
    }
    
    func selectedButtonStyle(button: UIButton) {
        button.do {
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .red500)
            $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
            $0.setTitleColor(.red500, for: .selected)
            $0.backgroundColor = .red100
            $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            $0.sizeToFit()
        }
    }
    
    @objc func dimmedViewDidTap() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc func filteringChipButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            selectedButtonStyle(button: sender)
        } else {
            defaultButtonStyle(button: sender)
        }
    }
}

private extension FilteringBottomSheetViewController {
    func setupAddTarget() {
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap)))
        
        [entireChipButton, less6000ChipButton, more6000ChipButton, latestChipButton, lowestChipButton, recommendChipButton].forEach { button in
            button.addTarget(self, action: #selector(filteringChipButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    func bindViewModels() {
        viewModel.getPriceCategoryFilterAPI { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.priceData = self.viewModel.priceFilters
                    if let entire = self.priceData.first(where: { $0.tag == nil}) {
                        self.entireChipButton.setTitle(StringLiterals.Home.entire, for: .normal)
                    }
                    
                    if let less6000 = self.priceData.first(where: { $0.tag == StringLiterals.FilteringTag.less6000 }) {
                        self.less6000ChipButton.setTitle(less6000.name, for: .normal)
                    }
                    
                    if let more6000 = self.priceData.first(where: { $0.tag == StringLiterals.FilteringTag.more6000 }){
                        self.more6000ChipButton.setTitle(more6000.name, for: .normal)
                    }
                }
            }
        }
        
        viewModel.getSortOptionFilterAPI { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.sortData = self.viewModel.sortOptions
                    if let latest = self.sortData.first(where: { $0.tag == StringLiterals.FilteringTag.latest }) {
                        self.latestChipButton.setTitle(latest.name, for: .normal)
                    }
                    
                    if let recommend = self.sortData.first(where: { $0.tag == StringLiterals.FilteringTag.recommended }) {
                        self.recommendChipButton.setTitle(recommend.name, for: .normal)
                    }
                    
                    if let lowestPrice = self.sortData.first(where: { $0.tag == StringLiterals.FilteringTag.lowestPrice }) {
                        self.lowestChipButton.setTitle(lowestPrice.name, for: .normal)
                    }
                }
            }
        }
    }
}
