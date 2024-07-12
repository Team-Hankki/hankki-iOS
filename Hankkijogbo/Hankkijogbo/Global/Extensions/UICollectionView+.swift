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
}
