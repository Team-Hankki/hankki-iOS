//
//  MyZipListBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

final class MyZipListBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let bottomSheetHandlerView = UIView()
    private let titleLabel = UILabel()
    private let addNewZipButton = UIButton()
    private let addNewZipLabel = UILabel()
    private let addNewZipStackView = UIStackView()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var myZipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.presentingViewController?.view.alpha = 0.33
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.presentingViewController?.view.alpha = 1
        }
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(
            bottomSheetHandlerView,
            titleLabel,
            addNewZipStackView,
            myZipCollectionView
        )
        addNewZipStackView.addArrangedSubviews(addNewZipButton, addNewZipLabel)
    }
    
    override func setupLayout() {
        bottomSheetHandlerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(4)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomSheetHandlerView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        addNewZipStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(56)
        }
        addNewZipButton.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.leading.equalToSuperview()
        }
        myZipCollectionView.snp.makeConstraints {
            $0.top.equalTo(addNewZipStackView.snp.bottom).offset(18)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        bottomSheetHandlerView.do {
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 2
        }
        titleLabel.do {
            $0.text = "나의 식당 족보"
            $0.textColor = .gray850
            $0.font = .setupPretendardStyle(of: .subtitle3)
        }
        addNewZipStackView.do {
            $0.axis = .horizontal
            $0.spacing = 18
            $0.alignment = .center
        }
        addNewZipButton.do {
            $0.backgroundColor = .gray
        }
        addNewZipLabel.do {
            $0.text = "새로운 족보 추가하기"
            $0.textColor = .gray800
            $0.font = .setupPretendardStyle(of: .body3)
        }
        flowLayout.do {
            $0.estimatedItemSize = .init(width: UIScreen.getDeviceWidth(), height: 56)
            $0.headerReferenceSize = .init(width: UIScreen.getDeviceWidth(), height: 35)
            $0.minimumLineSpacing = 12
            $0.scrollDirection = .vertical
        }
        myZipCollectionView.do {
            $0.backgroundColor = .gray50
        }
    }
}

private extension MyZipListBottomSheetViewController {
    
    // MARK: - Private Func
    
    func setupDelegate() {
        myZipCollectionView.delegate = self
        myZipCollectionView.dataSource = self
    }
    
    func setupRegister() {
        myZipCollectionView.register(
            MyZipListHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyZipListHeaderView.className
        )
        myZipCollectionView.register(
            MyZipListCollectionViewCell.self,
            forCellWithReuseIdentifier: MyZipListCollectionViewCell.className
        )
    }
}

// MARK: - UICollectionViewDataSource

extension MyZipListBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyZipListHeaderView.className,
                for: indexPath
              ) as? MyZipListHeaderView else {
            return UICollectionReusableView()
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyZipListCollectionViewCell.className, for: indexPath) as? MyZipListCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MyZipListBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CELL CLICK")
    }
}
