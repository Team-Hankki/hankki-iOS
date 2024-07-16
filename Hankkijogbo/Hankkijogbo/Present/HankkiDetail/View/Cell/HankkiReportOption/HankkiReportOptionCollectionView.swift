//
//  HankkiReportOptionCollectionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiReportOptionCollectionView: BaseView {
        
    // MARK: - UI Components
    
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Setup UI

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(331)
            $0.height.equalTo(285)
        }
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.itemSize = .init(width: 331, height: 52)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 8
            $0.headerReferenceSize = .init(width: 252, height: 27)
            $0.footerReferenceSize = .init(width: 275, height: 54)
            $0.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
        collectionView.do {
            $0.backgroundColor = .clear
        }
    }
}
