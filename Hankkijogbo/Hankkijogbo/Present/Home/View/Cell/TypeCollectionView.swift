//
//  TypeCollectionView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/10/24.
//

import UIKit

final class TypeCollectionView: BaseView {

    // MARK: - UI Components
    
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.convertByWidthRatio(592))
            $0.height.equalTo(60)
        }
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.minimumLineSpacing = 6
            $0.scrollDirection = .horizontal
        }
        
        collectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.showsHorizontalScrollIndicator = false
        }
    }
}
