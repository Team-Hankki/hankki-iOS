//
//  ReportCompleteViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/13/24.
//

import UIKit

final class ReportCompleteViewController: BaseViewController {
    
    // MARK: - Properties
    
    var reportedNumber: Int = 501
    var nickname: String = "은수"
    var selectedHankkiName: String = "고봉김밥집 1호점"
    
    var goToReportedHankkiString: String = "제보한 식당 보러가기"
    var updateStringNotificationName: String = "UpdateAddToMyZipListString"
    
    // MARK: - UI Components
    
    private let reportedNumberLabel: UILabel = UILabel()
    private let randomThanksLabel: UILabel = UILabel()
    
    private let hankkiImageView: UIImageView = UIImageView()
    private let hankkiOrangeGradientImageView: UIImageView = UIImageView()
    private lazy var hankkiInfoCardView: HankkiInfoCardView = HankkiInfoCardView(hankkiNameString: selectedHankkiName)
    
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(primaryButtonText: goToReportedHankkiString, primaryButtonHandler: bottomButtonPrimaryHandler)
    private let goToHomeButton: UIButton = UIButton()
    private let bottomGradientView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButtonView.setupEnabledDoneButton()
        setupAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupBottomGradientView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddToMyZipListString), name: NSNotification.Name(updateStringNotificationName), object: nil)
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
                withText: "\(reportedNumber)번째 식당을 등록했어요",
                color: .gray900
            )
        }
        randomThanksLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.body1,
                withText: "\(nickname)님이 모두의 지갑을 지켰어요!",
                color: .gray500
            )
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
                withText: "홈으로",
                color: .hankkiRed
            ), for: .normal)
        }
    }
}

private extension ReportCompleteViewController {
    
    // MARK: - Private Func
    
    func setupAddTarget() {
        goToHomeButton.addTarget(self, action: #selector(goToHomeButtonDidTap), for: .touchUpInside)
        hankkiInfoCardView.addToMyZipListButton.addTarget(self, action: #selector(addToMyZipListButtonDidTap), for: .touchUpInside)
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
    
    // MARK: - @objc Func
    
    @objc func bottomButtonPrimaryHandler() {
        print(goToReportedHankkiString)
    }
    
    @objc func addToMyZipListButtonDidTap() {
        // TODO: - API 연동하면서 제보한 식당 보러가기 액션 구현
        presentMyZipListBottomSheet()
    }
    
    @objc func updateAddToMyZipListString() {
        hankkiInfoCardView.addToMyZipListString = "다른 족보에도 추가"
    }
    
    @objc func goToHomeButtonDidTap() {
        let tabBarController = TabBarController()
        self.navigationController?.viewControllers = [tabBarController]
        self.navigationController?.popViewController(animated: true)
    }
}