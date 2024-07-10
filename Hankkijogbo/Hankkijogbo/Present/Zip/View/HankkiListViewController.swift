//
//  ZipHeaderCollectionView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 7/10/24.
//

import UIKit

final class  HankkiListViewController: BaseViewController {
    
    // MARK: - Properties
    
    let type: HankkiListViewControllerType
    
    private var dummyList = [1,2,3,4,5,6,7,8,9,10]
    
    // MARK: - UI Properties
    
    private lazy var hankkiTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycle
    
    init(_ type: HankkiListViewControllerType) {
        self.type = type
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupDelegate()
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        hankkiTableView.do {
            $0.backgroundColor = .hankkiWhite
            $0.isEditing = false
            $0.bounces = true
            $0.alwaysBounceVertical = true
        }
    }

    override func setupHierarchy() {
        view.addSubviews(hankkiTableView)
    }
    
    override func setupLayout() {
        hankkiTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension HankkiListViewController {
    func setupRegister() {
        hankkiTableView.register(ZipHeaderTableView.self, forHeaderFooterViewReuseIdentifier: ZipHeaderTableView.className)
        hankkiTableView.register(HankkiTableViewCell.self, forCellReuseIdentifier: HankkiTableViewCell.className)
    }
    
    func setupDelegate() {
        hankkiTableView.delegate = self
        hankkiTableView.dataSource = self
    }
    
    func setupNavigationBar() {
        let type: HankkiNavigationType
        
        type = HankkiNavigationType(
            hasBackButton: true,
            hasRightButton: false,
            mainTitle: .string("식당족보"),
            rightButton: .string(""),
            rightButtonAction: {},
            backgroundColor: self.type.navigationColor
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
     }
    
    /// 셀을 지우는 함수
    func deleteItem(at indexPath: IndexPath) {
        dummyList.remove(at: indexPath.row)
        
        hankkiTableView.beginUpdates()
        hankkiTableView.deleteRows(at: [indexPath], with: .automatic)
        hankkiTableView.endUpdates()
    }
}

extension HankkiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HankkiTableViewCell.className,
            for: indexPath
        ) as? HankkiTableViewCell else { return UITableViewCell() }
        
        cell.dataBind()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    /// 헤더 선택
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.type != .myZip {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ZipHeaderTableView.className
        )
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.type.tableViewHeight
    }
}

extension HankkiListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.type != .myZip {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            self.deleteItem(at: indexPath)
            // TODO: -api 연동 제대로하기
            print(indexPath.item, "번째 셀을 삭제했어요!!!!!!!!!!")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .hankkiRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && self.type == .myZip {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }

}
