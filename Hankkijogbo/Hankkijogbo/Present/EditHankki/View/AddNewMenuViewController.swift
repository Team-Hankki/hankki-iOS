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
        primaryButtonText: StringLiterals.EditHankki.addNewMenuPlease,
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
    
    /// 메뉴 셀 추가
    @objc func addMenuButtonDidTap() {
        viewModel.menus.append(MenuData())
        menuCollectionView.insertItems(at: [IndexPath(item: viewModel.menus.count - 1, section: ReportSectionType.menu.rawValue)])
    }
    
    /// 메뉴 셀 삭제
    @objc func deleteMenuButtonDidTap(_ sender: UIButton) {
        if !reportViewModel.menus.isEmpty {
            // 클릭된 버튼이 속해있는 셀의 IndexPath 구하기
            let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
            let itemIndexPath = self.collectionView.indexPathForItem(at: buttonPosition)
            
            guard let item = itemIndexPath?.item else { return }
            reportViewModel.menus.remove(at: item) // 해당 위치의 데이터 삭제
            collectionView.deleteItems(at: [IndexPath(item: item, section: ReportSectionType.menu.rawValue)]) // item 삭제
            collectionView.reloadSections(IndexSet(integer: ReportSectionType.menu.rawValue))
        }
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
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = AddNewMenuSectionType(rawValue: indexPath.section)
        switch sectionType {
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.className, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .addMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMenuCollectionViewCell.className, for: indexPath) as? AddMenuCollectionViewCell else { return UICollectionViewCell() }
            cell.addMenuButton.addTarget(self, action: #selector(addMenuButtonDidTap), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
