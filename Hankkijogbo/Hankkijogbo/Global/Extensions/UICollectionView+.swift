//
//  UICollectionView+.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/12/24.
//

import UIKit

extension UICollectionView {
    /// CollectionView의 HeaderView 또는 FooterView의 위치로 Scroll 시킬 때 사용하는 함수입니다.
    /// - kind: UICollectionView.elementKindSectionHeader 또는 UICollectionView.elementKindSectionFooter 값을 넣어준다.
    func scrollToSupplementaryView(ofKind kind: String, indexPath: IndexPath, scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        layoutIfNeeded()
        if let layoutAttributes = layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath) {
            let viewOrigin = CGPoint(x: layoutAttributes.frame.origin.x, y: layoutAttributes.frame.origin.y)
            var resultOffset: CGPoint = contentOffset
            
            switch scrollPosition {
            case UICollectionView.ScrollPosition.top:
                resultOffset.y = viewOrigin.y - contentInset.top
                
            case UICollectionView.ScrollPosition.left:
                resultOffset.x = viewOrigin.x - contentInset.left
                
            case UICollectionView.ScrollPosition.right:
                resultOffset.x = (viewOrigin.x - contentInset.left) - (frame.size.width - layoutAttributes.frame.size.width)
                
            case UICollectionView.ScrollPosition.bottom:
                resultOffset.y = (viewOrigin.y - contentInset.top) - (frame.size.height - layoutAttributes.frame.size.height)
                
            case UICollectionView.ScrollPosition.centeredVertically:
                resultOffset.y = (viewOrigin.y - contentInset.top) - (frame.size.height / 2 - layoutAttributes.frame.size.height / 2)
                
            case UICollectionView.ScrollPosition.centeredHorizontally:
                resultOffset.x = (viewOrigin.x - contentInset.left) - (frame.size.width / 2 - layoutAttributes.frame.size.width / 2)
            default:
                break
            }
            scrollRectToVisible(CGRect(origin: resultOffset, size: frame.size), animated: animated)
        }
    }
    
    /// CollectionView에서 특정 cell을 선택했을 경우 선택한 IndexPath의 cell을 화면 중앙에 위치하도록 Scroll 시킬 때 사용하는 함수입니다.
    /// 매개변수 indexPath: 선택된 셀의 IndexPath
    /// 셀을 중앙에 위치할 수 없을 경우(마지막 셀 근처일 경우), 가능한 범위 내에서 최적의 위치로 이동하게 합니다. 
    func scrollToCenter(at indexPath: IndexPath) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidth = layout.itemSize.width
        let cellHeight = layout.itemSize.height
        let spacing = layout.minimumLineSpacing
        let sectionInset = layout.sectionInset
        let collectionViewWidth = self.bounds.width
        
        let selectedCellFrame = CGRect(x: CGFloat(indexPath.item) * (cellWidth + spacing) + sectionInset.left,
                               y: 0,
                               width: cellWidth,
                               height: cellHeight)
        
        let targetOffsetX = selectedCellFrame.midX - (collectionViewWidth / 2 - cellWidth)
        let limitedOffsetX = max(0, min(targetOffsetX, self.contentSize.width - collectionViewWidth))
 
        self.setContentOffset(CGPoint(x: limitedOffsetX, y: 0), animated: true)
    }
}
