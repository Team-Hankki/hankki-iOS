//
//  SearchViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

struct SearchResultModel {
    var name: String
    var address: String
}

final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    let searchResultDummy: [SearchResultModel] = [
        SearchResultModel(name: "고동밥집 1호점", address: "서울특별시 마포구 갈매기 고양이처럼 울음"),
        SearchResultModel(name: "고동밥집 1호점", address: "서울특별시 마포구 갈매기 고양이처럼 울음"),
        SearchResultModel(name: "고동밥집 1호점", address: "서울특별시 마포구 갈매기 고양이처럼 울음"),
        SearchResultModel(name: "고동밥집 1호점", address: "서울특별시 마포구 갈매기 고양이처럼 울음"),
        SearchResultModel(name: "고동밥집 1호점", address: "서울특별시 마포구 갈매기 고양이처럼 울음")
    ]
    
    // MARK: - UI Properties
    
    private let searchGuideLabel: UILabel = UILabel()
    private let searchTextField: UITextField = UITextField()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var searchCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let searchIconImageView: UIImageView = UIImageView()
    private let searchBarBottomGradientView: UIView = UIView()
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: "삭당을 제보해주세요",
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        addViewGradient(searchBarBottomGradientView)
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            searchGuideLabel,
            searchTextField,
            searchCollectionView,
            searchBarBottomGradientView,
            bottomButtonView
        )
    }
    
    override func setupLayout() {
        searchGuideLabel.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).offset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(searchGuideLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(48)
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(18)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        searchBarBottomGradientView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(34)
            $0.height.equalTo(154)
        }
    }
    
    override func setupStyle() {
        searchGuideLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: "식당 이름으로 검색하면\n주소를 찾아 드릴게요",
                color: .gray900
            )
        }
        
        searchIconImageView.do {
            $0.image = .icSearch
            $0.frame = .init(x: 0, y: 0, width: 24, height: 24)
        }
        
        // TODO: - left padding 추가
        searchTextField.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray900.cgColor
            $0.leftView = searchIconImageView
            $0.leftViewMode = .always
        }
        
        searchCollectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.showsVerticalScrollIndicator = false
        }
    }
}

private extension SearchViewController {
    
    // MARK: - Private Func
    
    func setupRegister() {
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.className)
    }
    
    func setupDelegate() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    // TODO: - gradient 설정
    func addViewGradient(_ view: UIView) {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.white.withAlphaComponent(0).cgColor,
                UIColor.white.cgColor,
                UIColor.white.cgColor
            ]
            $0.locations = [0.0, 0.3, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 1.0)
            $0.endPoint = CGPoint(x: 0.5, y: 0.0)
//            $0.frame = self.view.bounds
        }
        
        view.layer.addSublayer(gradient)
    }
    
    @objc func bottomButtonPrimaryHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionView

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResultDummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.getDeviceWidth(), height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension SearchViewController: ChangeBottomButtonDelegate {
    func changeBottomButtonView(_ isDone: Bool) {
        if isDone {
            self.bottomButtonView.setupEnabledDoneButton()
        } else {
            self.bottomButtonView.setupDisabledDoneButton()
        }
    }
}
