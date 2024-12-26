//
//  RemoveHankkiViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 12/25/24.
//

import UIKit

// MARK: - 식당 정보가 실제와 다른가요?

final class RemoveHankkiViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: HankkiDetailViewModel
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    init(viewModel: HankkiDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
    }
    
    override func setupLayout() {
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .systemPink
        }
    }
}

// MARK: - Private Func

private extension HankkiDetailViewController {
    
}
