//
//  MypageViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class MypageViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var optionList: [MypageOptionCollectionViewCell.DataStruct] = [
        MypageOptionCollectionViewCell.DataStruct(title: "FAQ"),
        MypageOptionCollectionViewCell.DataStruct(title: "1:1 문의"),
        MypageOptionCollectionViewCell.DataStruct(title: "로그아웃")
    ]
    
    // MARK: - UI Properties
    
    private lazy var layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
        return self.setupCollectionViewSection(for: SectionType(rawValue: sectionIndex)!)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
         setupNavigationBar()
     }
    
    override func setupHierarchy() {
        view.addSubview(collectionView)
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
    
    func setupCollectionViewSection(for section: SectionType) -> NSCollectionLayoutSection {
        setupSection(section)
    }
    
    func setupNavigationBar() {
         let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                               hasRightButton: false,
                                                               mainTitle: .string("MY"),
                                                               rightButton: .string(""),
                                                               rightButtonAction: {})
                                                                 
        if let navigationController = navigationController as? HankkiNavigationController {
              navigationController.setupNavigationBar(forType: type)
        }
     }
    
    func showQuitAlert() {
        self.showAlert(
            image: "dummy",
            titleText: "소중한 족보가 사라져요",
            subText: "탈퇴 계정은 복구할 수 없어요",
            secondaryButtonText: "돌아가기",
            primaryButtonText: "탈퇴하기"
        )
    }
}

// MARK: - Delegate

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionType(rawValue: section)?.numberOfItemsInSection ?? 0
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
            )as! MypageQuitFooterView
            
            footerView.quitButtonHandler = {
                self.showQuitAlert()
            }
            
            return footerView
        
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionType(rawValue: indexPath.section) {
        case .zip:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageZipCollectionViewCell.className, for: indexPath) as? MypageZipCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .hankki:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageHankkiCollectionViewCell.className, for: indexPath) as? MypageHankkiCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .option:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageOptionCollectionViewCell.className, for: indexPath) as? MypageOptionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.dataBind(data: optionList[indexPath.item])
            return cell
            
        case .none:
            return UICollectionViewCell()
        }
    }
}

extension MypageViewController: UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupAction(SectionType(rawValue: indexPath.section)!, itemIndex: indexPath.item)
    }
}
