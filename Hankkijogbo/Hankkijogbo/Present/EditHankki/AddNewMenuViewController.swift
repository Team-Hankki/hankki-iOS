//
//  AddNewMenuViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/7/24.
//

import UIKit

enum AddNewMenuSectionType: Int {
    case menu
    case addMenu
}

final class AddNewMenuViewController: BaseViewController {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private lazy var menuFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var menuCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: menuFlowLayout)
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: "2" + StringLiterals.EditHankki.addMenuComplete,
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hankkiWhite
        
        setupRegister()
        setupDelegate()
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(titleLabel, menuCollectionView, bottomButtonView)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(154)
        }
    }
    
    override func setupStyle() {
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: StringLiterals.EditHankki.addNewMenuTitle,
                color: .gray850
            )
            $0.numberOfLines = 2
        }
        
        menuFlowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 26
            $0.itemSize = CGSize(width: view.frame.width - 22 - 14, height: 73)
            $0.sectionInset = UIEdgeInsets(top: 30, left: 22, bottom: 0, right: 0)
        }
    }
}

extension AddNewMenuViewController {
    func setupRegister() {
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.className)
        menuCollectionView.register(AddMenuCollectionViewCell.self, forCellWithReuseIdentifier: AddMenuCollectionViewCell.className)

    }
    
    func setupDelegate() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
    }
    
    @objc func bottomButtonPrimaryHandler() {
        print("메뉴 추가요 ㅋㅋ")
    }
}

extension AddNewMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = AddNewMenuSectionType(rawValue: section)
        switch sectionType {
        case .menu:
            return 2
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = AddNewMenuSectionType(rawValue: indexPath.section)
        switch sectionType {
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.className, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            cell.bindData(menu: MenuData(name: "네", price: 2000))
            return cell
        case .addMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMenuCollectionViewCell.className, for: indexPath) as? AddMenuCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
