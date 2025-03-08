//
//  MypageCollectionViewCellType.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/9/24.
//

import UIKit

private extension MypageViewController {
    func navigateToZipListViewController() {
            let zipListViewController = ZipListViewController()
            navigationController?.pushViewController(zipListViewController, animated: true)
    }
}

extension MypageViewController {
    enum SectionType: Int, CaseIterable {
        case hankki, option
        
        var numberOfItemsInSection: Int {
            switch self {
            case .hankki:
                3
            case .option:
                3
            }
        }
    }
    
    func setupAction(_ section: SectionType, itemIndex: Int) {
        switch section {
        case .hankki:
            switch itemIndex {
            case 0:
                SetupAmplitude.shared.logEvent(AmplitudeLiterals.Mypage.tabMyzip)
                navigateToZipListViewController()
            case 1:
                navigateToHankkiListViewController(.reported)
            default:
                navigateToHankkiListViewController(.liked)
            }
            
        case .option:
            switch itemIndex {
            case 0:
                if let url = URL(string: StringLiterals.ExternalLink.oneOnOne) {
                    UIApplication.shared.open(url, options: [:])
                }
            case 1:
                if let url = URL(string: StringLiterals.ExternalLink.terms) {
                    UIApplication.shared.open(url, options: [:])
                }
            case 2:
                self.showAlert(
                    titleText: StringLiterals.Alert.Logout.title,
                    secondaryButtonText: StringLiterals.Alert.Logout.secondaryButton,
                    primaryButtonText: StringLiterals.Alert.Logout.primaryButton,
                    secondaryButtonHandler: viewModel.patchLogout
                )
            default:
                return
            }
        }
    }
    
    func setupSection(_ section: SectionType) -> NSCollectionLayoutSection {
        switch section {
        case .hankki:
            return setupHankkiSection()
        case .option:
            return setupOptionSection()
        }
    }
}

// MARK: - setup CollectionView Section

private extension MypageViewController {

    func setupHankkiSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(55))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32 + 55 + 18))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        group.interItemSpacing = .fixed(20)
        group.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 30, bottom: 18, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: group)
        
        setupHeader(section)
        setupSeparator(section)
        return section
    }
    
    func setupOptionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        
        setupFooter(section)

        return section
    }
}

private extension MypageViewController {
    // 헤더 설정
    func setupHeader(_ section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(16 + 62))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
    }
    
    // 푸터 설정 (탈퇴하기)
    func setupFooter(_ section: NSCollectionLayoutSection) {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottomTrailing
        )
        
        section.boundarySupplementaryItems = [footer]
    }
    
    func setupSeparator(_ section: NSCollectionLayoutSection) {
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(10))
            
        let separator = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: separatorSize,
            elementKind: MypageSeparatorView.className,
            alignment: .bottomTrailing
        )
            
        section.boundarySupplementaryItems.append(separator)
    }
}
