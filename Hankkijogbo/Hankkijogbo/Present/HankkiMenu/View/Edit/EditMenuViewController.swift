//
//  EditMenuViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/10/24.
//

// MARK: - 메뉴 편집 화면

import UIKit

final class EditMenuViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: EditMenuViewModel
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = UILabel()
    private lazy var menuFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var menuCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: menuFlowLayout)
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: "",
        leftButtonText: StringLiterals.ModifyMenu.deleteMenuButton,
        rightButtonText: StringLiterals.ModifyMenu.modifyMenuButton,
        leftButtonHandler: deleteButtonHandler,
        rightButtonHandler: modifyButtonHandler
    )
    
    // MARK: - Life Cycle
    
    init(viewModel: EditMenuViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupRegister()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getMenuAPI {
            self.menuCollectionView.reloadData()
        }
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(
            titleLabel,
            menuCollectionView,
            bottomButtonView
        )
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(89)
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
                withText: StringLiterals.ModifyMenu.editMenuTitle,
                color: .gray900
            )
        }
        
        menuFlowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 0
            $0.itemSize = CGSize(width: view.frame.width, height: 60)
        }
        
        menuCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }
}

private extension EditMenuViewController {
    
    func bindViewModel() {
        viewModel.updateCollectionView = {
            self.menuCollectionView.reloadData()
        }
        
        viewModel.updateButton = { isActive in
            if isActive {
                self.bottomButtonView.setupEnabledDoneButton()
            } else {
                self.bottomButtonView.setupDisabledDoneButton()
            }
        }
    }
    
    func setupRegister() {
        menuCollectionView.register(EditMenuCollectionViewCell.self, forCellWithReuseIdentifier: EditMenuCollectionViewCell.className)
        menuCollectionView.register(
            BufferView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: BufferView.className
        )
    }

    func setupDelegate() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
    }
    
    func popToEditMenu() {
        if let editMenuViewController = navigationController?.viewControllers.first(where: {
            $0 is EditMenuViewController
        }) {
            navigationController?.popToViewController(editMenuViewController, animated: true)
        }
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - @objc Func
    
    @objc func deleteButtonHandler() {
        showAlert(titleText: StringLiterals.Alert.DeleteMenu.title,
                  secondaryButtonText: StringLiterals.Alert.DeleteMenu.secondaryButton,
                  primaryButtonText: StringLiterals.Alert.DeleteMenu.primaryButton,
                  primaryButtonHandler: deleteMenu)
    }
    
    @objc func deleteMenu() {
        viewModel.deleteMenuAPI { [self] in
            let completeView: MenuCompleteView = MenuCompleteView(
                firstSentence: StringLiterals.ModifyMenu.completeByYou,
                secondSentence: StringLiterals.ModifyMenu.deleteMenuComplete,
                completeImage: .imgDeleteComplete,
                doThisAgainButtonText: StringLiterals.ModifyMenu.editOtherMenuButton,
                doThisAgainButtonAction: { self.popToEditMenu() },
                completeButtonAction: { self.popToRoot() }
            )
            let deleteMenuCompleteViewController = CompleteViewController(completeView: completeView)
            navigationController?.pushViewController(deleteMenuCompleteViewController, animated: true)
        }
    }
    
    @objc func modifyButtonHandler() {
        guard let selectedMenu = viewModel.selectedMenu else { return }
        let modifyMenuViewModel = ModifyMenuViewModel(storeId: viewModel.storeId, selectedMenu: selectedMenu)
        let modifyMenuViewController = ModifyMenuViewController(viewModel: modifyMenuViewModel)
        self.navigationController?.pushViewController(modifyMenuViewController, animated: true)
    }
}

extension EditMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BufferView.className,
                for: indexPath
            ) as? BufferView else {
                return UICollectionReusableView()
            }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditMenuCollectionViewCell.className, for: indexPath) as? EditMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(viewModel.menus[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.cellForItem(at: indexPath) as? EditMenuCollectionViewCell != nil {
            if viewModel.menus[indexPath.row].isSelected {
                viewModel.menus[indexPath.row].isSelected = false
                return false
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) as? EditMenuCollectionViewCell != nil {
            viewModel.disableSelectedMenus()
            viewModel.menus[indexPath.row].isSelected = true
        }
    }
}

extension EditMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: UIScreen.getDeviceWidth(), height: 60)
    }
}
