//
//  ZipListViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class ZipListViewController: BaseViewController, NetworkResultDelegate {
    
    // MARK: - Properties
    
    private let viewModel: ZipListViewModel = ZipListViewModel()
    
    private var isEditMode: Bool = false {
         didSet {
             collectionView.reloadData()
             setupNavigationBar()
         }
     }
    
    // MARK: - UI Properties
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        viewModel.getZipList()
    }
    
    override func setupStyle() {
        collectionView.do {
            $0.allowsMultipleSelection = true
        }
    }
    
    override func setupHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

private extension ZipListViewController {
    private func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupRegister() {
        collectionView.register(ZipListCollectionViewCell.self, forCellWithReuseIdentifier: ZipListCollectionViewCell.className)
    }

    func setupDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
    }
    
    func setupNavigationBar() {
        var type: HankkiNavigationType

        if isEditMode {
            type = HankkiNavigationType(
                hasBackButton: true,
                hasRightButton: true,
                mainTitle: .string(StringLiterals.ZipList.navigation),
                rightButton: .string(StringLiterals.ZipList.navigationDelete),
                rightButtonAction: deleteButtonDidTap,
                backButtonAction: setIsEditMode
            )

        } else {
            type = HankkiNavigationType(
                hasBackButton: true,
                hasRightButton: true,
                mainTitle: .string(StringLiterals.ZipList.navigation),
                rightButton: .string(StringLiterals.ZipList.navigationEdit),
                rightButtonAction: editButtonDidTap
            )
        }
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
     }
    
    func editButtonDidTap() {
        isEditMode.toggle()
    }
    
    func deleteButtonDidTap() {
        // 현재 선택된 cell이 1개 이상일 때만 삭제가 가능합니다.
        if collectionView.indexPathsForSelectedItems?.count ?? 0 > 0 {
            showAlert(titleText: StringLiterals.Alert.DeleteZip.title,
                      secondaryButtonText: StringLiterals.Alert.back,
                      primaryButtonText: StringLiterals.Alert.DeleteZip.primaryButton,
                      primaryButtonHandler: deleteZip)
        }
    }
    
    func deselectedAllItems() {
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
            if let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell {
                cell.setSelected(false)
            }
        }
    }
    
    func navigateToHankkiListViewController(zipId: Int) {
        let hankkiListViewController = ZipDetailViewController(zipID: zipId)
            navigationController?.pushViewController(hankkiListViewController, animated: true)
    }
    
    func deleteZip() {
        let selectedItemItems: [Int] = collectionView.indexPathsForSelectedItems?
            .filter { $0.item != 0 }
            .map { indexPath in
                viewModel.zipList[indexPath.item - 1].id
            } ?? []
        
        let request: PostZipBatchDeleteRequestDTO = PostZipBatchDeleteRequestDTO(favoriteIds: selectedItemItems)
        viewModel.postZipBatchDelete(requestBody: request) {
            self.setIsEditMode()
            self.dismiss(animated: false) {
                self.viewModel.zipList = []
                self.viewModel.getZipList()
            }
        }
    }
    
    func setIsEditMode() {
        deselectedAllItems()
        isEditMode.toggle()
    }
}

private extension ZipListViewController {
    func setupCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 10
            $0.minimumLineSpacing = 14
            let itemWidth = (view.frame.width - 44 - layout.minimumInteritemSpacing) / 2
            $0.itemSize = CGSize(width: itemWidth,
                                 height: UIView.convertByAspectRatioHeight(itemWidth, width: 160, height: 230))
            $0.headerReferenceSize = CGSize(width: view.frame.width, height: 30)
            $0.footerReferenceSize = CGSize(width: view.frame.width, height: 22)
  
        }
        return layout
    }
    
    func navigateToCreateZipViewController() {
        let createZipViewController = CreateZipViewController(isBottomSheetOpen: false)
        navigationController?.pushViewController(createZipViewController, animated: true)
    }
}

// MARK: - delegate

extension ZipListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.zipList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ZipListCollectionViewCell.className,
            for: indexPath
        ) as? ZipListCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            let alpha: CGFloat = isEditMode ? 0.2 : 1.0
            cell.contentView.alpha = alpha
            
            cell.dataBind(ZipListCollectionViewCell.Model(
                id: -1,
                title: StringLiterals.ZipList.createZip,
                imageUrl: "",
                type: isEditMode ? ZipListCollectionViewCell.CellType.disable : ZipListCollectionViewCell.CellType.create)
            )
            cell.setSelected(false)
        } else {
            cell.dataBind(viewModel.zipList[indexPath.item - 1])
            
            let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            cell.setSelected(isSelected)
        }
        
        return cell
    }
}

extension ZipListViewController: UICollectionViewDelegate {
    /// Cell을 터치 했을 때 (선택)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell else { return }
        
            if isEditMode {
                if indexPath.item != 0 {
                    cell.setSelected(true)
                }
            } else {
                if indexPath.item == 0 {
                    SetupAmplitude.shared.logEvent(AmplitudeLiterals.ZipList.tabCreateZip)
                    navigateToCreateZipViewController()
                } else {
                    // 첫 족보 추가하기 셀은 리스트에 포함하지 않으므로 1을 뺀다
                    navigateToHankkiListViewController(zipId: self.viewModel.zipList[indexPath.item - 1].id)
                }
            }
        }
        
        /// Cell을 터치 했을 때 (해제)
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell else { return }
            
            if isEditMode && indexPath.item != 0 {
                cell.setSelected(false)
            }
        }
}
