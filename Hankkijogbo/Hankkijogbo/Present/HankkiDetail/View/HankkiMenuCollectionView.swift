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
    lazy var collectionView: UICollectionView = UICollectionView(frame: .init(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 179), collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.itemSize = .init(width: UIScreen.getDeviceWidth(), height: 45)
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
    
    /// 메뉴 데이터 불러온 이후에 메뉴 개수에 따라 높이 동적으로 설정
    func updateLayout(menuSize: Int) {
        collectionView.snp.removeConstraints()
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
            $0.height.equalTo(20 + 26 + 18 + (menuSize * (45 + 24)) + 48 + 18)
        }
        layoutIfNeeded()
    }
}
