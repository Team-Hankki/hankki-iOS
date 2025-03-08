//
//  ZipHeaderCollectionView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

class BaseHankkiListViewController: BaseViewController, NetworkResultDelegate {
    
    // MARK: - Properties
    
    let cellHeight: CGFloat = 102
    
    let viewModel: HankkiListViewModel = HankkiListViewModel()
    
    // MARK: - UI Properties
    
    lazy var emptyView: EmptyView = EmptyView(text: "")
    
    let hankkiTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupDelegate()
        
        bindViewModel()
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        hankkiTableView.do {
            $0.backgroundColor = .hankkiWhite
            $0.isEditing = false
            $0.bounces = true
            $0.alwaysBounceVertical = true
            $0.separatorStyle = .none
        }
        
        emptyView.do {
            $0.isHidden = true
        }
    }

    override func setupHierarchy() {
        view.addSubviews(hankkiTableView, emptyView)
    }
    
    override func setupLayout() {
        hankkiTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.centerY.equalTo(UIScreen.getDeviceHeight() / 2)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - method
    func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.emptyView.isHidden = (self?.viewModel.hankkiList.count != 0)
                self?.hankkiTableView.reloadData()
            }
        }
    }
}

private extension BaseHankkiListViewController {
    
    func setupRegister() {
        hankkiTableView.register(ZipHeaderTableView.self, forHeaderFooterViewReuseIdentifier: ZipHeaderTableView.className)
        hankkiTableView.register(ZipFooterTableView.self, forHeaderFooterViewReuseIdentifier: ZipFooterTableView.className)
        hankkiTableView.register(HankkiListTableViewCell.self, forCellReuseIdentifier: HankkiListTableViewCell.className)
    }
    
    func setupDelegate() {
        hankkiTableView.delegate = self
        hankkiTableView.dataSource = self
        viewModel.delegate = self
    }
    
}

extension BaseHankkiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hankkiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HankkiListTableViewCell.className,
                                                       for: indexPath
        ) as? HankkiListTableViewCell else { return UITableViewCell() }
        
        cell.dataBind(viewModel.hankkiList[indexPath.item],
                      isFinal: viewModel.hankkiList.count - 1 == indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension BaseHankkiListViewController: UITableViewDelegate {
    /// 터치시 식당 디테일로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushToDetailWithHankkiNavigation(hankkiId: viewModel.hankkiList[indexPath.item].id)
    }
}

extension BaseHankkiListViewController {
    
    /// Home View로 이동하는 함수
    func navigateToHomeView() {
        var rootViewController = self.view.window?.rootViewController

        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}
