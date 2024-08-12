//
//  HankkiDetailCollectionView.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailCollectionView: BaseView {

    // MARK: - UI Components
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 339, height: 349), collectionViewLayout: flowLayout)
    
    // MARK: - Life Cycle

    override func setupHierarchy() {
        addSubview(collectionView)
    }
    
    override func setupStyle() {
        flowLayout.do {
            $0.itemSize = .init(width: 252, height: 24)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 12
            $0.headerReferenceSize = .init(width: 252, height: 65)
            $0.footerReferenceSize = .init(width: 275, height: 42)
            $0.sectionInset = UIEdgeInsets(top: 32, left: 0, bottom: 38, right: 0)
        }
        collectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.layer.cornerRadius = 20
        }
    }
}

extension HankkiDetailCollectionView {
    
    /// 메뉴 데이터 불러온 이후에 컬뷰 레이아웃 업데이트 -> 메뉴 개수에 따라 높이 동적으로
    /// 그림자도 업데이트된 크기에 맞게 그려야 해서 layoutIfNeeded 이후에 addShadow
    func updateLayout(menuSize: Int) {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(339)
            $0.height.equalTo(240 + (menuSize * 36))
        }
        layoutIfNeeded()
        collectionView.addShadow(color: .black, alpha: 0.05, blur: 12, spread: 6)
    }
}
