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
    private let xIconButton: UIButton = UIButton()
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
        setupTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addViewGradient(searchBarBottomGradientView)
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            searchGuideLabel,
            searchTextField,
            searchIconImageView,
            xIconButton,
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
        
        searchIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.leading.equalTo(searchTextField).offset(10)
            $0.size.equalTo(24)
        }
        
        xIconButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchTextField).offset(-18)
            $0.size.equalTo(20)
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
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
        }
        xIconButton.do {
            $0.setImage(.btnPlusFilled, for: .normal)
            $0.isHidden = true
        }
        
        searchTextField.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray900.cgColor
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: "가게 이름으로 검색",
                color: .gray400
            )
            $0.addPadding(left: 40, right: 45)
            $0.changeBorderVisibility(isVisible: false, color: UIColor.gray900.cgColor)
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
        searchCollectionView.register(
            BufferView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BufferView.className
        )
        searchCollectionView.register(
            BufferView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: BufferView.className
        )
    }
    
    func setupDelegate() {
        searchTextField.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    func setupTarget() {
        xIconButton.addTarget(self, action: #selector(xIconButtonDidTap), for: .touchUpInside)
    }
    
    func addViewGradient(_ view: UIView) {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.white.withAlphaComponent(0).cgColor,
                UIColor.white.withAlphaComponent(0.5).cgColor,
                UIColor.white.cgColor
            ]
            $0.locations = [0.16, 0.61, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 1.0)
            $0.endPoint = CGPoint(x: 0.5, y: 0.0)
            $0.frame = searchBarBottomGradientView.bounds
        }
        
        view.layer.addSublayer(gradient)
    }
    
    /// isVisible 값에 따라 텍스트필드 사이드에 있는 X 버튼과 Eye 버튼의 isHidden 값을 변경한다.
    func changeSideButtonVisibility(isVisible: Bool) {
        xIconButton.isHidden = !isVisible
    }
}

private extension SearchViewController {
    
    // MARK: - @objc Func
    
    @objc func xIconButtonDidTap() {
        searchTextField.text = ""
    }
    
    @objc func bottomButtonPrimaryHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    /// 텍스트 필드 내용 수정을 시작할 때 호출되는 함수
    /// - 1. border를 활성화해준다.
    /// - 2. 텍스트가 채워져 있으면 바로 사이드 버튼들의 visibility를 변경한다.
    final func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !(textField.text ?? "").isEmpty {
            changeSideButtonVisibility(isVisible: true)
        }
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray900.cgColor
        return true
    }
    
    /// 텍스트 필드 내용 수정 중일 때 호출되는 함수
    /// - 사이드 버튼들의 visibility를 변경한다.
    final func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        changeSideButtonVisibility(isVisible: true)
        return true
    }
    
    /// 텍스트 필드 내용 수정이 끝났을 때 호출되는 함수
    /// - border를 제거해준다.
    final func textFieldDidEndEditing(_ textField: UITextField) {
        changeSideButtonVisibility(isVisible: false)
        textField.layer.borderWidth = 0
        textField.layer.borderColor = nil
    }
    
    /// 키보드의 return 키 클릭 시 호출되는 함수
    /// - 키보드를 내려준다
    final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionView

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BufferView.className,
            for: indexPath
        ) as? BufferView else {
            return UICollectionReusableView()
        }
        return reusableView
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: UIScreen.getDeviceWidth(), height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: UIScreen.getDeviceWidth(), height: 68 + 48)
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
