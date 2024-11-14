//
//  AddMenuViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/7/24.
//

import UIKit

enum AddMenuSectionType: Int {
    case menu
    case addMenu
}

final class AddMenuViewController: BaseViewController {
    
    // MARK: - Properties
    
    let storeId: Int
    private var viewModel: AddMenuViewModel = AddMenuViewModel()
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private lazy var menuFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var menuCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: menuFlowLayout)
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: String(viewModel.menus.count) + StringLiterals.AddMenu.addMenuComplete,
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    
    // MARK: - Life Cycle
    
    init(storeId: Int) {
        self.storeId = storeId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        bindViewModel()
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
            $0.bottom.equalTo(bottomButtonView.snp.top).offset(35)
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
                withText: StringLiterals.AddMenu.addNewMenuTitle,
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
        
        menuCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
}

// MARK: - Private Func

private extension AddMenuViewController {
    
    func setupRegister() {
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.className)
        menuCollectionView.register(AddMenuCollectionViewCell.self, forCellWithReuseIdentifier: AddMenuCollectionViewCell.className)
    }
    
    func setupDelegate() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
    }
    
    func bindViewModel() {
        viewModel.updateButton = { [weak self] isActive in
            self?.updateBottomButtonStyle(isActive: isActive)
        }
    }
    
    func scrollToFooterView() {
        let footerIndexPath = IndexPath(item: 0, section: AddMenuSectionType.addMenu.rawValue)
        menuCollectionView.scrollToSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, indexPath: footerIndexPath, scrollPosition: .top, animated: true)
    }
    
    func addMenuData() {
        if viewModel.menus.count == 1 {
            updateFirstXButtonIsHidden()
        }
        
        viewModel.menus.append(MenuData())
        menuCollectionView.insertItems(at: [IndexPath(item: viewModel.menus.count - 1, section: AddMenuSectionType.menu.rawValue)])
    }
    
    func removeMenuData(menuIndex: Int) {
        viewModel.menus.remove(at: menuIndex) // 해당 위치의 데이터 삭제
        menuCollectionView.deleteItems(at: [IndexPath(item: menuIndex, section: AddMenuSectionType.menu.rawValue)]) // item 삭제
        menuCollectionView.reloadSections(IndexSet(integer: AddMenuSectionType.menu.rawValue))
    }
    
    func updateBottomButtonStyle(isActive: Bool) {
        bottomButtonView.primaryButtonText = String(viewModel.menus.count) + StringLiterals.AddMenu.addMenuComplete
        
        if isActive {
            self.bottomButtonView.setupEnabledDoneButton()
        } else {
            self.bottomButtonView.setupDisabledDoneButton()
        }
    }
    
    func updateFirstXButtonIsHidden() {
        guard let cell = menuCollectionView.cellForItem(
            at: IndexPath(item: viewModel.menus.count - 1, section: AddMenuSectionType.menu.rawValue)
        ) as? MenuCollectionViewCell else { return }
        cell.deleteMenuButton.isHidden = false
    }
    
    // MARK: - @objc Func
    
    @objc func bottomButtonPrimaryHandler() {
        viewModel.postMenuAPI(storeId: storeId) { [self] in
            let completeView: MenuCompleteView = MenuCompleteView(
                firstSentence: StringLiterals.AddMenu.addMenuCompleteByYouFirst,
                secondSentence: "\(self.viewModel.validMenus.count)" + StringLiterals.AddMenu.addMenuCompleteByYouSecond,
                completeImage: .imgDeleteComplete
            )
            let addMenuCompleteViewController = CompleteViewController(completeView: completeView)
            navigationController?.pushViewController(addMenuCompleteViewController, animated: true)
        }
    }
    
    /// 메뉴 셀 추가
    @objc func addMenuButtonDidTap() {
        addMenuData()
        scrollToFooterView()
    }
    
    /// 메뉴 셀 삭제
    @objc func deleteMenuButtonDidTap(_ sender: UIButton) {
        if !viewModel.menus.isEmpty {
            // 클릭된 버튼이 속해있는 셀의 IndexPath 구하기
            let buttonPosition = sender.convert(CGPoint.zero, to: self.menuCollectionView)
            let itemIndexPath = self.menuCollectionView.indexPathForItem(at: buttonPosition)
            guard let item = itemIndexPath?.item else { return }
            removeMenuData(menuIndex: item)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension AddMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = AddMenuSectionType(rawValue: section)
        switch sectionType {
        case .menu:
            return viewModel.menus.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = AddMenuSectionType(rawValue: indexPath.section)
        switch sectionType {
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.className, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.bindData(menu: viewModel.menus[indexPath.row], isOnlyOne: viewModel.menus.count == 1)
            cell.deleteMenuButton.addTarget(self, action: #selector(deleteMenuButtonDidTap(_:)), for: .touchUpInside)
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

// MARK: - PassSelectedHankkiData Delegate

extension AddMenuViewController: PassItemDataDelegate {
    func updateViewModelLocationData(data: GetSearchedLocation?) {
        print("네엡")
    }
    
    func updateViewModelMenusData(cell: MenuCollectionViewCell, name: String, price: String) {
        guard let indexPath = menuCollectionView.indexPath(for: cell) else { return }
        viewModel.menus[indexPath.row] = MenuData(name: name, price: Int(price) ?? 0)
    }
}
