//
//  ZipViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

final class ZipListViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var isEditMode: Bool = false {
         didSet {
             collectionView.reloadData()
             setupNavigationBar()
         }
     }
    
    private let dummyZipList: [ZipListCollectionViewCell.DataStruct] = [
        ZipListCollectionViewCell.DataStruct(title: "박재연 화투 마스터"),
        ZipListCollectionViewCell.DataStruct(title: "김정욱 토스 슈퍼 디자이너 인턴"),
        ZipListCollectionViewCell.DataStruct(title: "디지털 신호처리 족보를 원하는 사람"),
        ZipListCollectionViewCell.DataStruct(title: "아 개강하기 너무 싫다 어떡해요?"),
        ZipListCollectionViewCell.DataStruct(title: "앱잼이란 것, 재밌는데 슬슬 자고싶다"),
        ZipListCollectionViewCell.DataStruct(title: "너무 힘들고 피곤한 하루"),
        ZipListCollectionViewCell.DataStruct(title: "배고파~"),
    ]
    
    // MARK: - UI Properties
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
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
        view.addSubviews(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(31)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

private extension ZipListViewController {
    func setupRegister() {
        collectionView.register(ZipListCollectionViewCell.self, forCellWithReuseIdentifier: ZipListCollectionViewCell.className)
    }

    func setupDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupNavigationBar() {
        let type: HankkiNavigationType

        if isEditMode {
            type = HankkiNavigationType(
                hasBackButton: true,
                hasRightButton: true,
                mainTitle: .string("나의 식당 족보"),
                rightButton: .string("삭제"),
                rightButtonAction: deleteButtonDidTap
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
        showAlert(titleText: "족보를 삭제할까요?", secondaryButtonText: "돌아가기", primaryButtonText: "삭제하기", primaryButtonHandler: deleteZip)
    }
    
    func deleteZip() {
        print(collectionView.indexPathsForSelectedItems?.map { $0.item } ?? [], "을 삭제합니다.")
        
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
            if let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell {
                cell.setSelected(false)
            }
        }
        
        isEditMode = false
        dismiss(animated: false)
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
  
        }
        return layout
    }
}

// MARK: - delegate

extension ZipListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyZipList.count + 1
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
                title: "새로운\n족보 리스트\n추가하기",
                type: isEditMode ? ZipListCollectionViewCell.CellType.disable : ZipListCollectionViewCell.CellType.create )
            )
        } else {
            cell.dataBind(dummyZipList[indexPath.item - 1])
        }
        
        return cell
    }
}

extension ZipListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell else { return }
        // TODO: - 뷰나오면 추가
            if isEditMode && indexPath.item != 0 {
                cell.setSelected(true)
            } else {
                if indexPath.item == 0 {
                    print("새로운 족보리스트 추가 뷰로 이동")
                } else {
                    print(indexPath.item, "번째 셀의 뷰로 이동")
                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ZipListCollectionViewCell else { return }
            
            if isEditMode && indexPath.item != 0 {
                cell.setSelected(false)
            }
        }
}
