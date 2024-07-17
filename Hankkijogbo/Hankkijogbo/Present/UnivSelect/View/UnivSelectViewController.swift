//
//  UnivSelectViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit

final class UnivSelectViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: UnivSelectViewModel = UnivSelectViewModel()

    // MARK: - UI Properties
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerTitleLabel: UILabel = UILabel()
    private let headerContentLabel: UILabel = UILabel()
    
    lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: "선택하기",
        lineButtonText: "찾는 대학교가 없어요. 우선 둘러볼게요!",
        primaryButtonHandler: bottomButtonPrimaryHandler,
        lineButtonHandler: bottomButtonLineHandler
    )
    
    private lazy var univCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupUnivCollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupRegister()
        
        viewModel.getUniversityList(completion: {_ in })
        setupViewModel()
    }
    
    override func setupStyle() {
        headerStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 38, left: 22, bottom: 10, right: 22)
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
        
        univCollectionView.do {
            $0.allowsMultipleSelection = false
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(
            headerStackView,
            univCollectionView,
            bottomButtonView
        )
        headerStackView.addArrangedSubviews(headerTitleLabel, headerContentLabel)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        univCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.bottom.equalTo(bottomButtonView.snp.top).offset(16 + 54)
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(154)
        }
    }
}

// MARK: - private Func

private extension UnivSelectViewController {
    private func setupViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.univCollectionView.reloadData()
            }
        }
    }
    
    func setupUnivCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 0
            $0.itemSize = CGSize(width: view.frame.width - 44, height: 39 + 14)
            $0.footerReferenceSize = CGSize(width: view.frame.width, height: 54)
        }
        
        return layout
    }
    
    // Todo: - 나중에 수정
    func bottomButtonPrimaryHandler() {
        print(viewModel.currentUniv, "을 선택했어요!")
    }
    
    func bottomButtonLineHandler() {
        print("지금 선택하지 않았어요")
    }
    
    func setupRegister() {
        univCollectionView.register(UnivCollectionViewCell.self, forCellWithReuseIdentifier: UnivCollectionViewCell.className)
    }

    func setupDelegate() {
        univCollectionView.dataSource = self
        univCollectionView.delegate = self
    }
}

// MARK: - delegate

extension UnivSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.universityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UnivCollectionViewCell.className,
            for: indexPath
        ) as? UnivCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(viewModel.universityList[indexPath.item].name, isFinal: viewModel.universityList.count == indexPath.item + 1)
        return cell
    }
}

extension UnivSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.currentUniv = viewModel.universityList[indexPath.item].name
        if !viewModel.currentUniv.isEmpty {
            bottomButtonView.setupEnabledDoneButton()
        }
    }
}

extension UnivSelectViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

