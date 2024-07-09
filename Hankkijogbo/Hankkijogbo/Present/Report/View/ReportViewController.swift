//
//  ReportViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit

final class ReportViewController: BaseViewController {
    
    // MARK: - Properties
    
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
    }
    
    func setupNavigationBar() {
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension ReportViewController: UICollectionViewDelegate {
    
}
