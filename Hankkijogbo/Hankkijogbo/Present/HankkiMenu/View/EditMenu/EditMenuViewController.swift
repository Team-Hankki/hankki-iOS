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
    
    //    let viewModel: EditMenuViewModel = EditMenuViewModel()
    
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
    
    //    init(viewModel: EditMenuViewModel) {
    //        self.viewModel = viewModel
    //        super.init()
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
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
        print("삭제")
    }
    
    @objc func modifyButtonHandler() {
        print("수정")
    }
}

extension EditMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditMenuCollectionViewCell.className, for: indexPath) as? EditMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(MenuData(name: "테스트핑", price: 7999))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EditMenuCollectionViewCell else { return }
        cell.radioButton.isSelected = !cell.radioButton.isSelected
    }
    
    /// didSelectItemAt 전에 호출되는 메서드
//    /// - 클릭된 카테고리를 한번 더 클릭 시 클릭을 해제시켜주기 위해 필요함
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell != nil {
//            if reportViewModel.categories[indexPath.row].isChecked {
//                reportViewModel.categories[indexPath.row].isChecked = false
//                return false
//            }
//        }
//        return true
//    }
//    
//    /// 다른 카테고리가 이미 선택되어 있다면 이를 해제하고 이번에 클릭된 카테고리를 활성화 시킨다
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell != nil {
//            reportViewModel.disableCheckedCategories()
//            reportViewModel.categories[indexPath.row].isChecked = true
//        }
//    }
}
