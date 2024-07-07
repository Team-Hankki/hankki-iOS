//
//  HankkiNavigationController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/6/24.
//

import UIKit

import SnapKit
import Then

final class HankkiNavigationController: UINavigationController {

    typealias ButtonAction = () -> Void
    private var rightButtonAction: ButtonAction? {
        didSet {
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        }
    }
    
    // MARK: - Properties

    private let navigationHeight: CGFloat = 50
    
    override var isNavigationBarHidden: Bool {
        didSet {
            hideDefaultNavigationBar()
            safeAreaView.isHidden = isNavigationBarHidden
            customNavigationBar.isHidden = isNavigationBarHidden
            setupSafeArea(navigationBarHidden: isNavigationBarHidden)
        }
    }
    
    // MARK: - UI Properties

    private let safeAreaView: UIView = UIView()
    private let customNavigationBar: UIView = UINavigationBar()
    
    private let leftStackView: UIStackView = UIStackView()
    private let mainImageView: UIImageView = UIImageView()
    private let mainTitleLabel: UILabel = UILabel()
    private let backButton: UIButton = UIButton()
    private var rightButton: UIButton = UIButton()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
        hideDefaultNavigationBar()
        setupSafeArea(navigationBarHidden: isNavigationBarHidden)
    }
}

extension HankkiNavigationController {
    /// NavigationBar를 세팅해주는 함수
    func setupNavigationBar(forType: HankkiNavigationType) {
        backButton.isHidden = !forType.hasBackButton
        rightButton.isHidden = !forType.hasRightButton
    
        setupMainTitle(stringOrImage: forType.mainTitle)
        setupRightButton(stringOrImage: forType.rightButton)
        
        rightButtonAction = forType.rightButtonAction
    }
}

// MARK: - Private Extensions

private extension HankkiNavigationController {
    
    func setupStyle() {
        customNavigationBar.do {
            $0.backgroundColor = .white
        }
        
        safeAreaView.do {
            $0.backgroundColor = customNavigationBar.backgroundColor
        }
        
        leftStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }
        
        mainTitleLabel.do {
            $0.font = .setupPretendardStyle(of: .h1)
            $0.textColor = .black
        }
        
        backButton.do {
            $0.setImage(.icArrowBack, for: .normal)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        rightButton.do {
            $0.titleLabel?.font = .setupPretendardStyle(of: .body1)
            $0.setTitleColor(.gray600, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView, customNavigationBar)
        customNavigationBar.addSubviews(leftStackView, rightButton)
        leftStackView.addArrangedSubviews(backButton, mainTitleLabel, mainImageView)
    }
    
    func setupLayout() {
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(navigationHeight)
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        safeAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    /// navigationBar가 hidden 상태인지 아닌지에 따라 view의 safeArea를 정해주는 함수
    func setupSafeArea(navigationBarHidden: Bool) {
        if navigationBarHidden {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        } else {
            additionalSafeAreaInsets = UIEdgeInsets(top: navigationHeight,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        }
    }
    
    /// DefaultNavigationBar를 hidden 시켜주는 함수
    func hideDefaultNavigationBar() {
        navigationBar.isHidden = true
    }
    
    func setupMainTitle(stringOrImage: StringOrImageType) {
        switch stringOrImage {
        case .string(let string):
            mainImageView.isHidden = true
            mainTitleLabel.isHidden = false
            mainTitleLabel.text = string
        case .image(let image):
            mainTitleLabel.isHidden = true
            mainImageView.isHidden = false
            mainImageView.image = image
        }
    }
    
    func setupRightButton(stringOrImage: StringOrImageType) {
        switch stringOrImage {
        case .string(let string):
            rightButton.setImage(nil, for: .normal)
            rightButton.setTitle(string, for: .normal)
        case .image(let image):
            rightButton.setTitle(nil, for: .normal)
            rightButton.setImage(image, for: .normal)
        }
    }
    
    @objc func backButtonTapped() {
        popViewController(animated: true)
    }
    
    @objc func rightButtonTapped() {
        rightButtonAction?()
    }
}
