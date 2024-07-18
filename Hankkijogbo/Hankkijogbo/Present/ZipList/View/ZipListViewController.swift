//
//  ZipListViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class ZipListViewController: BaseViewController {
    
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
        
        setupViewModel()
        viewModel.getZipList(completion: {_ in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         setupNavigationBar()
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
    private func setupViewModel() {
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
    }
    
    func setupNavigationBar() {
        var type: HankkiNavigationType

        if isEditMode {
            type = HankkiNavigationType(
                hasBackButton: true,
                hasRightButton: true,
                mainTitle: .string("나의 식당 족보"),
                rightButton: .string("삭제"),
                rightButtonAction: deleteButtonDidTap,
                backButtonAction: setIsEditMode
            )

        } else {
            type = HankkiNavigationType(
                hasBackButton: true,
                hasRightButton: true,
                mainTitle: .string("나의 식당 족보"),
                rightButton: .string("편집"),
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
        showAlert(titleText: "족보를 삭제할까요?", 
                  secondaryButtonText: "돌아가기",
                  primaryButtonText: "삭제하기",
                  primaryButtonHandler: deleteZip)
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
        let hankkiListViewController = HankkiListViewController(.myZip,zipId: zipId)
            navigationController?.pushViewController(hankkiListViewController, animated: true)
    }
    
    func deleteZip() {
        let selectedItemItems = collectionView.indexPathsForSelectedItems?
            .map { $0.item }
            .filter { $0 != 0 } ?? []
        
        print(selectedItemItems, "을 삭제합니다.")
        setIsEditMode()
        dismiss(animated: false)
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
        let createZipViewController = CreateZipViewController()
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
            
            cell.dataBind(ZipListCollectionViewCell.DataStruct(
                id: -1,
                title: "새로운\n족보 리스트\n추가하기",
                imageUrl: "",
                type: isEditMode ? ZipListCollectionViewCell.CellType.disable : ZipListCollectionViewCell.CellType.create )
            )
        } else {
            cell.dataBind(viewModel.zipList[indexPath.item - 1])
        }
        
        return cell
    }
}

extension ZipListViewController: UICollectionViewDelegate {
    /// Cell을 터치 했을 때 (선택)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell else { return }
        
        // TODO: - 뷰나오면 추가
            if isEditMode {
                if indexPath.item != 0 {
                    cell.setSelected(true)
                }
            } else {
                if indexPath.item == 0 {
                    navigateToCreateZipViewController()
                } else {
                    print(indexPath.item, "번째 셀의 뷰로 이동")
                    navigateToHankkiListViewController(zipId: self.viewModel.zipList[indexPath.item].id)
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
