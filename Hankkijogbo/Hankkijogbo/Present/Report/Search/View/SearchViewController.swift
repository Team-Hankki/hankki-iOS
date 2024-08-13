//
//  SearchViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/11/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: SearchViewModel
    
    weak var delegate: PassItemDataDelegate?
    private let debouncer: HankkiDebouncer = HankkiDebouncer(seconds: 0.5)
    
    // MARK: - UI Components
    
    private let searchGuideLabel: UILabel = UILabel()
    private let searchTextField: UITextField = UITextField()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var searchCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let searchIconImageView: UIImageView = UIImageView()
    private let searchTextDeleteButton: UIButton = UIButton()
    private let searchBarBottomGradientView: UIView = UIView()
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(
        primaryButtonText: StringLiterals.Report.reportHankki,
        primaryButtonHandler: bottomButtonPrimaryHandler
    )
    private lazy var emptyView = EmptyView(
        text: "'\(searchTextField.text ?? "")'" + StringLiterals.Report.emptySearchResult
    )
    
    // MARK: - Init
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.removeAllLocations()

        setupRegister()
        setupDelegate()
        setupAddTarget()
        bindViewModel()
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
            searchTextDeleteButton,
            searchCollectionView,
            searchBarBottomGradientView,
            bottomButtonView,
            emptyView
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
        
        searchTextDeleteButton.snp.makeConstraints {
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
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(128)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(112)
            $0.height.equalTo(166)
        }
    }
    
    override func setupStyle() {
        searchGuideLabel.do {
            $0.numberOfLines = 2
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: StringLiterals.Report.searchHankkiByName,
                color: .gray900
            )
        }
        
        searchIconImageView.do {
            $0.image = .icSearch
        }
        
        searchTextDeleteButton.do {
            $0.setImage(.btnDeleteBig, for: .normal)
            $0.isHidden = true
        }
        
        searchTextField.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray900.cgColor
            $0.attributedPlaceholder = UILabel.setupAttributedText(
                for: PretendardStyle.body6,
                withText: StringLiterals.Report.searchSecondPlaceHolder,
                color: .gray400
            )
            $0.addPadding(left: 40, right: 45)
            $0.changeBorderVisibility(isVisible: false, color: UIColor.gray900.cgColor)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.autocapitalizationType = .none
        }
        
        searchCollectionView.do {
            $0.backgroundColor = .hankkiWhite
            $0.showsVerticalScrollIndicator = false
        }
        
        emptyView.do {
            $0.isHidden = true
        }
    }
}

extension SearchViewController {
    func bindViewModel() {
        viewModel.updateLocations = {
            self.updateEmptyView()
            self.searchCollectionView.reloadData()
        }
        
        viewModel.selectLocation = {
            self.delegate?.updateViewModelLocationData(data: self.viewModel.selectedLocationData)
        }
        
        viewModel.completeLocationSelection = {
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.showAlertToMove = {
            self.showAlert(
                titleText: StringLiterals.Alert.alreadyReportHankki,
                secondaryButtonText: StringLiterals.Alert.no,
                primaryButtonText: StringLiterals.Alert.move,
                primaryButtonHandler: self.pushToHankkiDetail
            )
        }
        
        viewModel.showAlertToAdd = {
            self.showAlert(
                titleText: StringLiterals.Alert.alreadyReportHankkiByOther,
                secondaryButtonText: StringLiterals.Alert.back,
                primaryButtonText: StringLiterals.Alert.add,
                primaryButtonHandler: self.viewModel.postHankkiFromOtherAPI
            )
        }
        
        viewModel.moveToDetail = {
            self.pushToHankkiDetail()
        }
    }
}

private extension SearchViewController {
        
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
    
    func setupAddTarget() {
        searchTextDeleteButton.addTarget(self, action: #selector(searchTextDeleteButtonDidTap), for: .touchUpInside)
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
        searchTextDeleteButton.isHidden = !isVisible
    }
    
    func updateEmptyView() {
        if let currentSearchedText = searchTextField.text {
            if !currentSearchedText.isEmpty {
                emptyView.isHidden = viewModel.searchedLocationResponseData?.locations.count != 0
                emptyView.text = "'\(currentSearchedText)'" + StringLiterals.Report.emptySearchResult
                emptyView.setupTextLabelColor(start: 0, end: currentSearchedText.count + 2, color: .gray800)
            } else {
                emptyView.isHidden = true
            }
        } else {
            emptyView.isHidden = true
        }
    }
    
    func pushToHankkiDetail() {
        guard let hankkiId = viewModel.storeId else { return }
        let hankkiDetailViewController = HankkiDetailViewController(hankkiId: hankkiId)
        navigationController?.pushViewController(hankkiDetailViewController, animated: true)
    }
}

// MARK: - @objc Func

private extension SearchViewController {
    
    @objc func searchTextDeleteButtonDidTap() {
        searchTextField.text = nil
        viewModel.removeAllLocations()
    }
    
    @objc func bottomButtonPrimaryHandler() {
        guard let university = UserDefaults.standard.getUniversity() else { return }
        guard let hankkiLocation = viewModel.selectedLocationData else { return }
        let request = PostHankkiValidateRequestDTO(universityId: university.id, latitude: hankkiLocation.latitude, longitude: hankkiLocation.longitude)
        viewModel.postHankkiValidateAPI(req: request)
    }
}

// MARK: - UITextField Delegate

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
    
    /// 텍스트필드 타이핑이 멈추었을 때 호출되는 함수
    /// - currentSearchedText 값 업데이트
    /// - debouncer 실행해서 API 호출
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let query = self.searchTextField.text else { return }
        // TODO: - query.isEmpty일 때 보내면(-> 검색창 싹다 지웠을 때 발생함) 초기화를 위해 빈 locations 달라고 요청해야할 것 같다
        if !query.isEmpty {
            debouncer.run {
                self.viewModel.getSearchedLocationAPI(query: query)
            }
        }
    }
    
    /// 키보드의 return 키 클릭 시 호출되는 함수
    /// - 키보드를 내려준다
    final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionView Delegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        viewModel.searchedLocationResponseData?.locations.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath) as? SearchCollectionViewCell,
              let locations = viewModel.searchedLocationResponseData?.locations else { return UICollectionViewCell() }
        cell.delegate = self
        cell.bindLocationData(model: locations[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedLocationData = viewModel.searchedLocationResponseData?.locations[indexPath.item]
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

// MARK: - ChangeBottomButton Delegate

extension SearchViewController: ChangeBottomButtonDelegate {
    func changeBottomButtonView(_ isDone: Bool) {
        if isDone {
            self.bottomButtonView.setupEnabledDoneButton()
        } else {
            self.bottomButtonView.setupDisabledDoneButton()
        }
    }
}
