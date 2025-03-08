//
//  HankkiMenuCollectionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiMenuCollectionView: BaseView {

    // MARK: - UI Components
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
            $0.height.equalTo(179)
        }
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 24
            $0.headerReferenceSize = .init(width: UIScreen.getDeviceWidth(), height: 20 + 26)
            $0.footerReferenceSize = .init(width: UIScreen.getDeviceWidth(), height: 48 + 18)
            $0.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 24, right: 0)
        }
        
        collectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.isScrollEnabled = false
        }
    }
}

extension HankkiMenuCollectionView {
    
    func updateLayout() {
        collectionView.snp.updateConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
            $0.height.equalTo(collectionView.contentSize.height)
        }
    }
}
