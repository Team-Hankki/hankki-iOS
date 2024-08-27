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

protocol BaseViewControllerDelegate: AnyObject {
    func setupLoading(_ isLoading: Bool, type: LoadingViewType)
}

/// 모든 UIViewController는 BaseViewController를 상속 받는다.
/// - 각 함수를 override하여 각 VC에 맞게 함수 내용을 작성한다.
/// - 각 VC에서는 해당 함수들을 호출하지 않아도 된다.
class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    private var loadingViewType: LoadingViewType = .none
    private var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateLoadingView(for: self.loadingViewType)
            }
        }
    }
    
    // MARK: - UI Components
    
    let loadingView: FullLoadingView = FullLoadingView()
    
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
        view.backgroundColor = .white
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        
        setupLoadingView()
        
        setUpKeyboard()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkService.shared.setupDelegate(self)
    }
    
    // MARK: - Set UI
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupStyle() { }
}

extension BaseViewController: BaseViewControllerDelegate {
    func setupLoading(_ isLoading: Bool, type: LoadingViewType) {
        self.loadingViewType = type
        self.isLoading = isLoading
    }
}


// Loading View
private extension BaseViewController {
    // Loading View의 초기 설정을 합니다.
    func setupLoadingView() {
        NetworkService.shared.setupDelegate(self)
        
        view.addSubviews(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // Loading State에 맞게 Loading View를 update합니다.
    func updateLoadingView(for type: LoadingViewType) {
        print("🥕 \(self) \(isLoading) \(type)")
        switch type {
        case .fullView, .submit:
            if isLoading {
                loadingView.showLoadingView(type)
            } else {
                loadingView.dismissLoadingView(type)
            }
        
        case .none:
            print("empty loading")
        }
    }
}
