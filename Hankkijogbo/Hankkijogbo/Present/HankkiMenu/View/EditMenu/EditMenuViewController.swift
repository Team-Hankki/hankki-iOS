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
    
    let titleLabel: UILabel = UILabel()
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
        
        setupRegister()
        setupDelegate()
        bindViewModel()
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
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.itemSize = CGSize(width: view.frame.width, height: 64)
        }
        
        bottomButtonView.do {
            $0.setupEnabledDoneButton()
        }
    }
}

private extension EditMenuViewController {
    
    func setupRegister() {
        menuCollectionView.register(EditMenuCollectionViewCell.self, forCellWithReuseIdentifier: EditMenuCollectionViewCell.className)
    }

    func setupDelegate() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
    }

    func bindViewModel() {
        
    }
    
    // MARK: - @objc Func
    
    @objc func deleteButtonHandler() {
//        viewModel.deleteMenuAPI(storeId: storeId, id: <#T##Int#>) {
//            <#code#>
//        }
    }
    
    @objc func modifyButtonHandler() {
//        viewModel.modifyMenuAPI(storeId: storeId, id: <#T##Int#>, requestBody: <#T##[MenuData]#>) {
//            <#code#>
//        }
        print("1030 \(viewModel.menus.filter { $0.isSelected })")
    }
}

extension EditMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditMenuCollectionViewCell.className, for: indexPath) as? EditMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(viewModel.menus[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if collectionView.cellForItem(at: indexPath) as? EditMenuCollectionViewCell != nil {
//            if viewModel.menus[indexPath.row].isSelected {
//                viewModel.menus[indexPath.row].isSelected = false
//                return false
//            }
//        }
//        return true
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? EditMenuCollectionViewCell else { return }
        viewModel.disableSelectedMenus()
        viewModel.menus[indexPath.row].isSelected = true
    }
}
