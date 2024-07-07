//
//  BaseViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 6/30/24.
//

import UIKit

import SnapKit
import Then

/// 모든 UIViewController는 BaseViewController를 상속 받는다.
/// - 각 함수를 override하여 각 VC에 맞게 함수 내용을 작성한다.
/// - 각 VC에서는 해당 함수들을 호출하지 않아도 된다.
class BaseViewController: UIViewController {
    
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
    }

    // MARK: - Set UI
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupStyle() { }
}
