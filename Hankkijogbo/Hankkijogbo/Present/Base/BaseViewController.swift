//
//  BaseViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 6/30/24.
//

import UIKit

import Lottie
import SnapKit
import Then

/// 모든 UIViewController는 BaseViewController를 상속 받는다.
/// - 각 함수를 override하여 각 VC에 맞게 함수 내용을 작성한다.
/// - 각 VC에서는 해당 함수들을 호출하지 않아도 된다.
class BaseViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let spinner: LottieAnimationView = LottieAnimationView()
    private let loadingView: UIView = UIView()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hankkiWhite

        setupHierarchy()
        setupLayout()
        setupStyle()
        
        setupLoadingView()
        
        setUpKeyboard()
        hideKeyboard()
    }

    // MARK: - Set UI
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupStyle() { }
}

private extension BaseViewController {
    func setupLoadingView() {
        loadingView.do {
            $0.backgroundColor = .white.withAlphaComponent(0.5)
            $0.isHidden = true
        }
        
        spinner.do {
            $0.animation = LottieAnimation.named("loading")
            $0.contentMode = .scaleAspectFill
            $0.loopMode = .loop
            $0.stop()
        }
        
        view.addSubview(loadingView)
        loadingView.addSubview(spinner)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spinner.snp.makeConstraints {
            $0.size.equalTo(68)
            $0.center.equalToSuperview()
        }
    }
}

extension BaseViewController {
    func showLoadingView() {
        loadingView.do {
            print("✏️✏️✏️ 로딩뷰 쇼")
            $0.isHidden = false
        }
        
        spinner.do {
            $0.play()
        }
    }
    
    func dismissLoadingView() {
        loadingView.do {
            print("✏️✏️✏️ 로딩뷰 클로즈")
            $0.isHidden = true
        }
        
        spinner.do {
            $0.stop()
        }
    }
}
