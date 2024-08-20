//
//  UnivSelectViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/8/24.
//

import UIKit
import CoreLocation

protocol UnivSelectViewControllerDelegate: AnyObject {
    func didRequestLocationFocus()
    func didSelectUniversity(name: String)
}

final class UnivSelectViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: UnivSelectViewModel = UnivSelectViewModel()
    weak var delegate: UnivSelectViewControllerDelegate?
    
    // MARK: - UI Properties
    
    private let headerStackView: UIStackView = UIStackView()
    private let headerTitleLabel: UILabel = UILabel()
    private let headerContentLabel: UILabel = UILabel()
    
    private let topGradientView: UIView = UIView()
    
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
        
        viewModel.getUniversityList()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.isNavigationBarHidden = true
        }
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
                for: PretendardStyle.body5,
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
            topGradientView,
            bottomButtonView
        )
        headerStackView.addArrangedSubviews(headerTitleLabel, headerContentLabel)
    }
    
    override func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        topGradientView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(headerStackView.snp.bottom).inset(10)
            $0.height.equalTo(35)
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
    func bindViewModel() {
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
    
    func setupGradient() {
       let gradient = CAGradientLayer()
        // TODO: - 서현) 윤정이가 그라디언트 수정해주면 값 반영하기
        gradient.do {
            $0.colors = [
                UIColor.white.cgColor,
                UIColor.white.withAlphaComponent(0.8).cgColor,
                UIColor.white.withAlphaComponent(0).cgColor,
              ]
            $0.locations = [0.0, 0.2, 1.0]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            $0.frame = topGradientView.bounds
        }
        
        topGradientView.layer.addSublayer(gradient)
    }
    
    func bottomButtonPrimaryHandler() {
        viewModel.postMeUniversity()
        
        let selectedUniversityName = viewModel.universityList[viewModel.currentUnivIndex].name
        delegate?.didSelectUniversity(name: selectedUniversityName)
    }
    
    func bottomButtonLineHandler() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.didRequestLocationFocus()
            navigationController?.popViewController(animated: true)
        case .restricted, .denied:
            // 위치 정보 접근이 거부된 경우, 서울시립대학교로 포커싱
            viewModel.currentUnivIndex = 24
            viewModel.postMeUniversity()
        case .notDetermined:
            // 위치 정보 접근 권한이 아직 결정되지 않은 경우 동의 요청
            if let homeVC = self.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
                homeVC.requestLocationAuthorization()
            }
        @unknown default:
            break
        }
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
        
        cell.dataBind(viewModel.universityList[indexPath.item].name,
                      isFinal: indexPath.item == viewModel.universityList.count - 1)
        return cell
    }
}

extension UnivSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.currentUnivIndex = indexPath.item
        if viewModel.currentUnivIndex != -1 {
            bottomButtonView.setupEnabledDoneButton()
        }
    }
}

extension UnivSelectViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
