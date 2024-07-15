//
//  HankkiDetailCollectionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailCollectionView: BaseView {

    // MARK: - UI Components
    
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 339, height: 349), collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(339)
            $0.height.equalTo(349)
        }
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.itemSize = .init(width: 252, height: 24)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 12
            $0.headerReferenceSize = .init(width: 252, height: 68)
            $0.footerReferenceSize = .init(width: 275, height: 42)
            $0.sectionInset = UIEdgeInsets(top: 32, left: 0, bottom: 38, right: 0)
        }
        collectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 20
            $0.addShadow(color: .black, alpha: 0.05, blur: 12, spread: 6)
        }
    }
}
