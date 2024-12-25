//
//  RemoveOptionCollectionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class RemoveOptionCollectionView: BaseView {
        
    // MARK: - UI Components
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Setup UI

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(172)
        }
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.scrollDirection = .vertical
            $0.itemSize = .init(width: UIScreen.getDeviceWidth(), height: 52)
            $0.minimumLineSpacing = 8
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    }
}
