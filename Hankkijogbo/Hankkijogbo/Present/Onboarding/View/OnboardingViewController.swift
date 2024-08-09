//
//  OnboardingViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/19/24.
//

import UIKit
import Lottie

final class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties

    private let onboardingModelData: [OnboardingModel] = getOnboardingModelData()
    private var currentAnimationIndex = 0
    private lazy var currentData: OnboardingModel = self.onboardingModelData[0] {
        didSet {
            updateData()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var animationView: LottieAnimationView = LottieAnimationView()
    private let nextButton: UIButton = UIButton()
    private let titleLabel: UILabel = UILabel()
    private let skipButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    // MARK: - Setup UI
    
    override func setupStyle() {
        animationView.do {
            $0.contentMode = .scaleAspectFill
            $0.loopMode = .loop
        }
        
        nextButton.do {
            $0.setupPadding(top: 15, leading: 38, bottom: 15, trailing: 38)
            $0.makeRoundBorder(cornerRadius: 16, borderWidth: 0, borderColor: .clear)
        }
        
        titleLabel.do {
            $0.numberOfLines = 0
        }
        
        skipButton.do {
            $0.setupPadding(top: 8, leading: 8, bottom: 8, trailing: 8)
            $0.setupBackgroundColor(.clear)
        }
        
        updateData()
    }
    
    override func setupHierarchy() {
        view.addSubviews(animationView, nextButton, titleLabel, skipButton)
    }
    
    override func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(22)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(56)
        }
        
        skipButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(14)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(37)
            $0.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            let topPadding = 812 / UIScreen.getDeviceHeight() * 110
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
            $0.bottom.equalToSuperview()
        }
    }
}

private extension OnboardingViewController {
    func setupAddTarget() {
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
    }
    
    @objc func nextButtonDidTap() {
        if isFinal() {
            // 온보딩의 마지막일 경우, 대학선택으로 이동
            presentUnivSelectView()
        } else {
            // 온보딩의 마지막 페이지가 아니면, 다음 로티로 이동
            currentAnimationIndex += 1
            currentData = onboardingModelData[currentAnimationIndex]
        }
    }
    
    @objc func skipButtonDidTap() {
        presentUnivSelectView()
    }
    
    func presentUnivSelectView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let navigationController = HankkiNavigationController(rootViewController: TabBarController())
                window.rootViewController = navigationController
                navigationController.pushViewController(UnivSelectViewController(), animated: false)
            }
        }
    }
    
    func isFinal() -> Bool {
        return currentAnimationIndex == (onboardingModelData.count - 1)
    }
    
    func updateData() {
        view.backgroundColor = currentData.backgroundColor
        
        if isFinal() {
            let attributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "시작하기",
                color: .hankkiWhite
            )
            animationView.do {
                $0.contentMode = .scaleAspectFill
                $0.loopMode = .playOnce
            }
            nextButton.do {
                $0.setupBackgroundColor(.gray900)
                $0.setAttributedTitle(attributedTitle, for: .normal)
            }
            animationView.snp.remakeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            let nextAttributedTitle = UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: currentData.nextButtonText,
                color: .hankkiWhite
            )
            nextButton.do {
                $0.setAttributedTitle(nextAttributedTitle, for: .normal)
                $0.setupBackgroundColor(currentData.nextButtonColor)
            }
        }
        
        let skipAttributedTitle = UILabel.setupAttributedText(
            for: PretendardStyle.subtitle3,
            withText: "건너뛰기",
            color: currentData.skipButtonColor
        )
        skipButton.do {
            $0.setAttributedTitle(skipAttributedTitle, for: .normal)
        }
        
        let titleAttributedText = UILabel.setupAttributedText(
            for: SuiteStyle.h1,
            withText: currentData.titleText,
            color: currentData.titleColor
        )
        titleLabel.do {
            $0.attributedText = titleAttributedText
        }
        
        animationView.do {
            $0.animation = LottieAnimation.named(currentData.lottieFileName)
            $0.play()
        }

    }
}
