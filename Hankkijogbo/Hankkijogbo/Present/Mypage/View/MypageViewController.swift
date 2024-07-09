//
//  MypageViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class MypageViewController: BaseViewController {
    
    // MARK: - Properties
    
    lazy var optionList: [MypageOptionCollectionViewCellStruct] = [
        MypageOptionCollectionViewCellStruct(title: "FAQ", onTab: {print("FAQ로 이동")}),
        MypageOptionCollectionViewCellStruct(title: "1:1 문의", onTab: {print("1:1 문의로 이동")}),
        MypageOptionCollectionViewCellStruct(title: "로그아웃", onTab: {
            self.showAlert(
                image: "dummy",
                titleText: "정말 로그아웃 하실 건가요?",
                subText: "Apple 계정을 로그아웃합니다",
                secondaryButtonText: "돌아가기",
                primaryButtonText: "로그아웃"
            )
        })
    ]
    
    // MARK: - UI Properties
    
    lazy var layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
        return self.setupCollectionViewSection(for: sectionIndex)
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
    }
    
    override func setupHierarchy() {
        view.addSubviews(collectionView)
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension MypageViewController {
    
    func setupRegister() {
        collectionView.register(MypageZipCollectionViewCell.self, forCellWithReuseIdentifier: MypageZipCollectionViewCell.className)
        collectionView.register(MypageHankkiCollectionViewCell.self, forCellWithReuseIdentifier: MypageHankkiCollectionViewCell.className)
        collectionView.register(MypageOptionCollectionViewCell.self, forCellWithReuseIdentifier: MypageOptionCollectionViewCell.className)
        
        collectionView.register(MypageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MypageHeaderView.className)
        collectionView.register(MypageQuitFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MypageQuitFooterView.className)
    }
    
    func setupDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCollectionViewSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch sectionIndex {
        case 0:
            return setupZipSection()
        case 1:
            return setupHankkiSection()
        case 2:
            return setupOptionSection()
        default:
            return setupZipSection()
        }
    }
    
    func setupSection(itemSize: NSCollectionLayoutSize, groupSize: NSCollectionLayoutSize) -> NSCollectionLayoutSection {
        let itemSize = itemSize
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = groupSize
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func setupZipSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection = setupSection(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(72)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(72))
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(196)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        
        return section
    }
    
    func setupHankkiSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(94/(375-44))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .flexible(21)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 22, bottom: 8, trailing: 22)
        
        return section
    }
    
    func setupOptionSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection = setupSection(
            itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(60)),
            groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(60))
        )

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(48)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottomTrailing
        )
        
        section.boundarySupplementaryItems = [footer]

        return section
    }
}

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return optionList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageHeaderView.className,
                for: indexPath
            )
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MypageQuitFooterView.className,
                for: indexPath
            )
            
            return footerView
        
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageZipCollectionViewCell.className, for: indexPath) as? MypageZipCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
                
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageHankkiCollectionViewCell.className, for: indexPath) as? MypageHankkiCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
                
            case 2:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageOptionCollectionViewCell.className, for: indexPath) as? MypageOptionCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.dataBind(data: optionList[indexPath.item])
                return cell
                
            default:
                return UICollectionViewCell()
            }
    }
}

extension MypageViewController: UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath[0] {
        //TODO: - 페이지 생기면 함수 수정
        case 0:
            return print("나의 한끼 족보로 이동")
        
        case 1:
            return print("제보하거나 좋아요한 한끼 식당 리스트로 이동")
        
        case 2:
            let selectedOption = optionList[indexPath.item]
            selectedOption.onTab()
            
        default:
            return
        }
    }
}
