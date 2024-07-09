//
//  ReportViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class ReportViewController: BaseViewController {
    
    // MARK: - Properties
    
    let dummy = ["한식", "분식", "중식", "일식", "간편식", "패스트푸드", "양식", "샐러드/샌드위치", "세계음식"]
    
    // MARK: - UI Properties
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = ReportCompositionalFactory.create()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
    private let reportButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            collectionView,
            reportButton
        )
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reportButton.snp.top).offset(-20)
        }
        reportButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.width.equalTo(311)
            $0.height.equalTo(50)
        }
    }
    
    override func setupStyle() {
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .white
        }
        reportButton.do {
            $0.titleLabel?.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "제보하기",
                color: .hankkiWhite
            )
            $0.backgroundColor = .hankkiRed
            $0.layer.cornerRadius = 16
        }
    }
}

extension ReportViewController {
    
    // MARK: - Func
    
}

private extension ReportViewController {
    
    // MARK: - Private Func
    
    func setupRegister() {
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.className)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
        collectionView.register(
            ReportHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ReportHeaderView.className
        )
    }
    
    func setupNavigationBar() {
        // TODO: - 백버튼 액션
        // TODO: - 네비 타이틀 폰트 설정
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: true,
                                                              hasRightButton: true,
                                                              mainTitle: .string("제보하기"),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {})
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    // MARK: - @objc
    
    // MARK: - Layout
}

// MARK: - UICollectionView Delegate

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ReportHeaderView.className,
                for: indexPath
              ) as? ReportHeaderView else {
            return UICollectionReusableView()
        }
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = ReportSectionType(rawValue: section)
        switch sectionType {
        case .search:
            return 1
        case .category:
            return dummy.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = ReportSectionType(rawValue: indexPath.section)

        switch sectionType {
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(dummy[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ReportViewController: UICollectionViewDelegate {
    
}
