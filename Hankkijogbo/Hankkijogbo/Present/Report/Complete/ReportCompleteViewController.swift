//
//  ReportCompleteViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/13/24.
//

import UIKit

final class ReportCompleteViewController: BaseViewController {
    
    // MARK: - Properties
    
    let hankkiId: Int64
    let reportedNumber: Int
    let nickname: String
    let selectedHankkiName: String
    
    private let randomThanksMessages: [String] = [
        StringLiterals.Report.randomThanksMessageVer1,
        StringLiterals.Report.randomThanksMessageVer2,
        StringLiterals.Report.randomThanksMessageVer3
    ]
        
    // MARK: - UI Components
    
    private let reportedNumberLabel: UILabel = UILabel()
    private let randomThanksLabel: UILabel = UILabel()
    
    private let hankkiImageView: UIImageView = UIImageView()
    private let hankkiOrangeGradientImageView: UIImageView = UIImageView()
    private lazy var hankkiInfoCardView: HankkiInfoCardView = HankkiInfoCardView(hankkiNameString: selectedHankkiName)
    
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(primaryButtonText: StringLiterals.Report.goToReportedHankki, primaryButtonHandler: bottomButtonPrimaryHandler)
    private let goToHomeButton: UIButton = UIButton()
    private let bottomGradientView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    init(hankkiId: Int64,
         reportedNumber: Int,
         nickname: String,
         selectedHankkiName: String) {
        self.hankkiId = hankkiId
        self.reportedNumber = reportedNumber
        self.nickname = nickname
        self.selectedHankkiName = selectedHankkiName
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupBottomGradientView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupNotification()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            reportedNumberLabel,
            randomThanksLabel,
            hankkiOrangeGradientImageView,
            hankkiImageView,
            bottomGradientView,
            hankkiInfoCardView,
            bottomButtonView,
            goToHomeButton
        )
    }
    
    override func setupLayout() {
        reportedNumberLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().inset(22)
        }
        randomThanksLabel.snp.makeConstraints {
            $0.top.equalTo(reportedNumberLabel.snp.bottom).offset(4)
            $0.leading.equalTo(reportedNumberLabel)
        }
        hankkiImageView.snp.makeConstraints {
            $0.top.equalTo(randomThanksLabel.snp.bottom).offset(UIScreen.convertByHeightRatio(103))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.convertByWidthRatio(312))
            $0.height.equalTo(UIScreen.convertByHeightRatio(372))
        }
        hankkiOrangeGradientImageView.snp.makeConstraints {
            $0.centerX.bottom.equalTo(hankkiImageView)
            $0.width.equalTo(UIScreen.convertByWidthRatio(468))
            $0.height.equalTo(UIScreen.convertByHeightRatio(468))
        }
        bottomGradientView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.convertByHeightRatio(374))
        }
        hankkiInfoCardView.snp.makeConstraints {
            $0.bottom.equalTo(bottomButtonView.snp.top).offset(-50)
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.height.equalTo(74)
        }
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(UIScreen.hasNotch ? view.safeAreaLayoutGuide : -10)
            $0.height.equalTo(154)
        }
        goToHomeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.hasNotch ? 32 : 12)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    override func setupStyle() {
        reportedNumberLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: "\(reportedNumber)\(StringLiterals.Report.hankkiReportComplete)",
                color: .gray900
            )
        }
        randomThanksLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.body1,
                withText: nickname + getRandomThanksMessage(),
                color: .gray500
            )
            $0.numberOfLines = 0
        }
        hankkiOrangeGradientImageView.do {
            $0.image = .imgOrangeGradient
            $0.contentMode = .scaleAspectFill
        }
        hankkiImageView.do {
            $0.image = .imgStore
        }
        goToHomeButton.do {
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.subtitle2,
                withText: StringLiterals.Common.goToHome,
                color: .hankkiRed
            ), for: .normal)
        }
        bottomButtonView.do {
            $0.setupEnabledDoneButton()
        }
    }
}

private extension ReportCompleteViewController {
    
    // MARK: - Private Func
    
    func setupNavigationBar() {
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: false,
                                                              hasRightButton: false,
                                                              mainTitle: .string(StringLiterals.Common.report),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {},
                                                              backgroundColor: .clear)
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func setupAddTarget() {
        goToHomeButton.addTarget(self, action: #selector(goToHomeButtonDidTap), for: .touchUpInside)
        hankkiInfoCardView.addToMyZipListButton.addTarget(self, action: #selector(addToMyZipListButtonDidTap), for: .touchUpInside)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddToMyZipListString), name: NSNotification.Name(StringLiterals.NotificationName.updateAddToMyZipList), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupWhiteToast), name: NSNotification.Name(StringLiterals.NotificationName.setupToast), object: nil)
    }
    
    func setupBottomGradientView() {
        let gradient = CAGradientLayer()
        
        gradient.do {
            $0.colors = [
                UIColor.hankkiWhite.withAlphaComponent(0).cgColor,
                UIColor.hankkiWhite.cgColor,
                UIColor.hankkiWhite.cgColor
            ]
            $0.locations = [0.0, 0.24, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            $0.frame = self.bottomGradientView.bounds
        }
        
        self.bottomGradientView.layer.addSublayer(gradient)
    }
    
    func getRandomThanksMessage() -> String {
        return randomThanksMessages.randomElement() ?? StringLiterals.Report.randomThanksMessageVer1
    }
}

private extension ReportCompleteViewController {
    
    // MARK: - @objc Func
    
    @objc func bottomButtonPrimaryHandler() {
        let hankkiDetailViewController = HankkiDetailViewController(hankkiId: hankkiId)
        navigationController?.pushViewController(hankkiDetailViewController, animated: true)
    }
    
    @objc func addToMyZipListButtonDidTap() {
        presentMyZipListBottomSheet(id: hankkiId)
    }
    
    @objc func updateAddToMyZipListString() {
        hankkiInfoCardView.addToMyZipListString = StringLiterals.MyZip.addToOtherZip
    }
    
    @objc func setupWhiteToast(_ notification: Notification) {
        if let zipId = notification.userInfo?["zipId"] as? Int {
            
            self.showWhiteToast(message: StringLiterals.Toast.addToMyZipWhite) { [self] in
                let hankkiListViewController = HankkiListViewController(.myZip, zipId: zipId)
                navigationController?.pushViewController(hankkiListViewController, animated: true)
            }
        }
    }
    
    @objc func goToHomeButtonDidTap() {
        let tabBarController = TabBarController()
        self.navigationController?.viewControllers = [tabBarController]
        self.navigationController?.popViewController(animated: true)
    }
}
