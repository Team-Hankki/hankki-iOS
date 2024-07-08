//
//  UnivSelectViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class UnivSelectViewController: BaseViewController {
    
    // MARK: - Properties
    
    var currentUniv: String = ""

    // MARK: - UI Properties
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerTitleLabel: UILabel = UILabel()
    private let headerContentLabel: UILabel = UILabel()
    
    private let bottomButtonView: UIView = UIView()
    private let doneButton: UIButton = UIButton()
    private let laterButton: UIButton = UIButton()
    
    private lazy var univCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupUnivCollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonAction()
        setupDelegate()
        setupRegister()
    }
    
    override func setupStyle() {
        headerStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 38, left: 22, bottom: 34, right: 22)
        }
        
        headerTitleLabel.do {
            $0.numberOfLines = 1
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h1,
                withText: "나의 대학교를 선택해보세요",
                color: .gray900
            )
        }
        
        headerContentLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: PretendardStyle.body4,
                withText: "아직 등록되지 않은 대학(지역)이 있어요.\n조금만 기다려주세요 :)",
                color: .gray400
            )
        }
        
        bottomButtonView.do {
            $0.backgroundColor = .hankkiWhite
        }
        
        doneButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "선택하기",
                color: .hankkiWhite
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
                $0.backgroundColor = .hankkiRed
                $0.layer.cornerRadius = 16
            }
        }
        
        laterButton.do {
            if let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.button,
                withText: "찾는 대학교가 없어요. 우선 둘러볼게요!",
                color: .gray400
            ) {
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(headerStackView, univCollectionView, bottomButtonView)
        headerStackView.addArrangedSubviews(headerTitleLabel, headerContentLabel)
        bottomButtonView.addSubviews(doneButton, laterButton)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        univCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.bottom.equalTo(bottomButtonView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(54)
        }
        
        laterButton.snp.makeConstraints {
            $0.top.equalTo(doneButton.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - private Func

private extension UnivSelectViewController {
    func setupUnivCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 14
            $0.itemSize = CGSize(width: view.frame.width-44, height: 39)
        }
        
        return layout
    }
    
    // MARK: - @objc
    
    @objc func doneButtonDidTap() {
        print("선택하기 버튼이 클릭되었습니다.")
    }
    
    @objc func laterButtonDidTap() {
        print("찾는대학이 없는 버튼이 클릭되었습니다.")
    }
    
    // MARK: - setupAction
    
    func setupButtonAction() {
        doneButton.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        
        laterButton.addTarget(self, action: #selector(laterButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - setupRegister
    
    func setupRegister() {
        univCollectionView.register(UnivCollectionViewCell.self, forCellWithReuseIdentifier: UnivCollectionViewCell.className)
    }
    
    // MARK: - setupDelegate
    
    func setupDelegate() {
        univCollectionView.dataSource = self
    }
}

// MARK: - delegate

extension UnivSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UnivCollectionViewCell.className,
            for: indexPath
        ) as? UnivCollectionViewCell else { return UICollectionViewCell() }
//        cell.dataBind(itemData[indexPath.item], itemRow: indexPath.item)
        return cell
    }
}
