//
//  HankkiDetailViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/15/24.
//

import UIKit

final class HankkiDetailViewController: BaseViewController, NetworkResultDelegate {
    
    // MARK: - Properties
    
    let hankkiId: Int
    var viewModel: HankkiDetailViewModel = HankkiDetailViewModel()
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let lightGrayBackgroundView: UIView = UIView()
    private let backButton: UIButton = UIButton()
    private let topBlackGradientImageView: UIImageView = UIImageView()
    private let thumbnailImageView: UIImageView = UIImageView()
    private let differentInfoView: DifferentInfoView = DifferentInfoView()
    private let hankkiInfoView: HankkiInfoView = HankkiInfoView()
    
    // MARK: - Life Cycle
    
    init(hankkiId: Int) {
        self.hankkiId = hankkiId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        setupAddTarget()
        setupGesture()
        setupNotification()
        bindViewModel()
        getHankkiDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            lightGrayBackgroundView,
            thumbnailImageView,
            backButton,
            differentInfoView,
            hankkiInfoView
        )
        thumbnailImageView.addSubview(topBlackGradientImageView)
    }
    
    override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(-UIApplication.getStatusBarHeight())
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth())
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(235)
        }
        
        topBlackGradientImageView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView)
            $0.size.equalTo(thumbnailImageView)
        }
        
        lightGrayBackgroundView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48.5)
            $0.leading.equalToSuperview().inset(7)
            $0.size.equalTo(40)
        }
        
        differentInfoView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-12)
        }
        
        hankkiInfoView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .gray50
        }
        
        scrollView.do {
            $0.backgroundColor = .clear
        }
        
        lightGrayBackgroundView.do {
            $0.backgroundColor = .gray50
        }
        
        backButton.do {
            $0.setImage(.btnBackWhite, for: .normal)
        }
    }
}

private extension HankkiDetailViewController {
    
    // MARK: - Private Func
    
    func bindViewModel() {
        viewModel.setHankkiDetailData = { [weak self] in
            if let data = self?.viewModel.hankkiDetailData {
                if let first = data.imageUrls.first {
                    self?.setupImageStyle(imageUrl: first)
                } else {
                    self?.setupNoImageStyle()
                }
            }
        }
        
        viewModel.showAlert = { [weak self] _ in
            self?.showAlert(titleText: StringLiterals.Alert.unknownError,
                            subText: StringLiterals.Alert.tryAgain,
                            primaryButtonText: StringLiterals.Alert.check)
        }
        
        viewModel.dismiss = {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func setupRegister() {
        // 메뉴판 컬뷰 예정
    }
    
    func setupDelegate() {
        scrollView.delegate = self
        viewModel.delegate = self
    }
    
    func setupAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    func setupGesture() {
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(backButtonDidTap))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadHankkiDetailNotification),
            name: NSNotification.Name(StringLiterals.NotificationName.reloadHankkiDetail),
            object: nil
        )
    }
    
    func getHankkiDetail() {
        viewModel.getHankkiDetailAPI(hankkiId: hankkiId)
    }
    
    func setupNoImageStyle() {
        contentView.do {
            $0.backgroundColor = .gray300
        }
        thumbnailImageView.do {
            $0.image = .imgDetailDefault
        }
        topBlackGradientImageView.do {
            $0.image = nil
        }
    }
    
    func setupImageStyle(imageUrl: String) {
        thumbnailImageView.do {
            $0.setKFImage(url: imageUrl)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        topBlackGradientImageView.do {
            $0.image = .imgBlackGradient
        }
    }
    
    /// 정말 제보하시겠어요? Alert 띄우기
    func showCheckAlertForReport() {
        self.showAlert(
            titleText: StringLiterals.Alert.reallyReport,
            subText: StringLiterals.Alert.disappearInfoByReport,
            secondaryButtonText: StringLiterals.Alert.back,
            primaryButtonText: StringLiterals.Common.report,
            primaryButtonHandler: deleteHankkiByReport
        )
    }
    
    /// 제보를 통한 식당 삭제
    func deleteHankkiByReport() {
        viewModel.deleteHankkiAPI(id: hankkiId) { [self] in
            showThanksAlert()
        }
    }
    
    /// 제보 감사 Alert 띄우기
    func showThanksAlert() {
        let nickname: String = UserDefaults.standard.getNickname()

        self.showAlert(
            image: .imgModalReport,
            titleText: nickname + StringLiterals.Alert.thanksForReport,
            primaryButtonText: StringLiterals.Alert.back,
            primaryButtonHandler: dismissAlertAndPop,
            hightlightedText: nickname,
            hightlightedColor: .red500
        )
    }
    
    /// Alert를 fade out으로 dismiss 시킴과 동시에 VC를 pop
    func dismissAlertAndPop() {
        backButtonDidTap()
    }
}

extension HankkiDetailViewController {
    
    // MARK: - @objc Func
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editMenuButtonDidTap() {
        SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabMenuEdit)
        
        guard let menus = viewModel.hankkiDetailData?.menus else { return }
        let selectableMenus: [SelectableMenuData] = menus.map { menu in
            SelectableMenuData(isSelected: false, id: menu.id, name: menu.name, price: menu.price)
        }
        
        let editHankkiBottomSheet = HankkiNavigationController(
            rootViewController: EditHankkiBottomSheetViewController(
                storeId: self.hankkiId,
                selectableMenus: selectableMenus
            )
        )
        editHankkiBottomSheet.modalTransitionStyle = .crossDissolve
        editHankkiBottomSheet.modalPresentationStyle = .overFullScreen
        self.present(editHankkiBottomSheet, animated: true, completion: nil)
    }
    
    @objc func addMyZipButtonDidTap() {
        presentMyZipListBottomSheet(id: hankkiId)
    }
    
    @objc func hankkiReportButtonDidTap() {
        showCheckAlertForReport()
    }
    
    @objc func setupBlackToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showBlackToast(message: StringLiterals.Toast.addToMyZipBlack) { [self] in
                let hankkiListViewController = HankkiListViewController(.myZip, zipId: zipId)
                navigationController?.pushViewController(hankkiListViewController, animated: true)
            }
        }
    }
    
    @objc func reloadHankkiDetailNotification() {
        getHankkiDetail()
    }
}

extension HankkiDetailViewController: UIScrollViewDelegate {
    
    /// 상단의 bounces만 비활성화
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -UIApplication.getStatusBarHeight() {
            scrollView.contentOffset.y = -UIApplication.getStatusBarHeight()
        }
    }
}
