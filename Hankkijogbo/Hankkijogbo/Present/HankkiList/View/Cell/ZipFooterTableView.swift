//
//  ZipFooterTableView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/15/24.
//

import UIKit

final class ZipFooterTableView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    weak var viewController: HankkiListViewController?
        
    // MARK: - UI Components
    
    private lazy var button: MoreButton = MoreButton(buttonText: StringLiterals.HankkiList.moreButton, 
                                                     buttonAction: { [weak self] in self?.viewController?.navigateToHomeView()
    })
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
}

private extension ZipFooterTableView {
    func setupHierarchy() {
        addSubview(button)
    }
    
    func setupLayout() {
        button.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
