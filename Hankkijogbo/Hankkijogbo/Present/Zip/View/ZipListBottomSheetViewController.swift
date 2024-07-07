//
//  ZipListBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/7/24.
//

import UIKit

import SnapKit
import Then

final class ZipListBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let bottomSheetHandlerView = UIView()
    private let titleLabel = UILabel()
    private let addNewZipButton = UIButton()
    private let addNewZipLabel = UILabel()
    private let addNewZipStackView = UIStackView()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var zipCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupRegister()
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubview(zipCollectionView)
    }
    
    override func setupLayout() {
        zipCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        zipCollectionView.do {
            $0.backgroundColor = .red
        }
    }
}

extension ZipListBottomSheetViewController {
    
    // MARK: - Func
    
}

private extension ZipListBottomSheetViewController {
    
    // MARK: - Private Func
    
    func setupDelegate() {
        zipCollectionView.delegate = self
        zipCollectionView.dataSource = self
    }
    
    func setupRegister() {
        zipCollectionView.register(
            ZipListCollectionViewCell.self,
            forCellWithReuseIdentifier: ZipListCollectionViewCell.className
        )
    }
}

// MARK: - UICollectionViewDataSource

extension ZipListBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZipListCollectionViewCell.className, for: indexPath) as? ZipListCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ZipListBottomSheetViewController: UICollectionViewDelegate {
    
}
