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
    let viewModel: HankkiListViewModel = HankkiListViewModel()

    // MARK: - UI Properties
    
    private let hankkiTableView = UITableView(frame: .zero, style: .grouped)
    private lazy var emptyView = EmptyView(
        text: type.emptyViewLabel,
        buttonText: type == .myZip ? "식당 구경하러 가기" : nil,
        buttonAction: type == .myZip ? self.navigateToHomeView : nil
    )
    
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
        setupDelegate()
        
        setupViewModel()
        viewModel.getMeHankkiList(type.userTargetType, completion: {_ in})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        hankkiTableView.do {
            $0.backgroundColor = .hankkiWhite
            $0.isEditing = false
            $0.bounces = true
            $0.alwaysBounceVertical = true
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
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(type.headrViewHeight)
        }
    }
}

private extension HankkiListViewController {
    private func setupViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.emptyView.isHidden = (self?.viewModel.hankkiList.count != 0)
                self?.hankkiTableView.reloadData()
            }
        }
    }
    
    func setupRegister() {
        hankkiTableView.register(ZipHeaderTableView.self, forHeaderFooterViewReuseIdentifier: ZipHeaderTableView.className)
        hankkiTableView.register(ZipFooterTableView.self, forHeaderFooterViewReuseIdentifier: ZipFooterTableView.className)
        hankkiTableView.register(HankkiListTableViewCell.self, forCellReuseIdentifier: HankkiListTableViewCell.className)
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
            mainTitle: .string(self.type.navigationTitle),
            rightButton: .string(""),
            rightButtonAction: {},
            backgroundColor: self.type.navigationColor
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
     }
}

extension HankkiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hankkiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HankkiListTableViewCell.className,
        for: indexPath
        ) as? HankkiListTableViewCell else { return UITableViewCell() }
        
        cell.dataBind(viewModel.hankkiList[indexPath.item], isLikeButtonDisable: self.type != .liked)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    /// 나의 족보 리스트 헤더 세팅
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
        return self.type.headrViewHeight
    }
    
    /// 나의 족보 리스트 푸터 세팅
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.type != .myZip || viewModel.hankkiList.count == 0 {
            return nil
        }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ZipFooterTableView.className
        ) as? ZipFooterTableView ?? ZipFooterTableView(reuseIdentifier: ZipFooterTableView.className)
        footerView.viewController = self
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.type != .myZip || viewModel.hankkiList.count == 0 {
            return 0
        } else {
            return 112
        }
    }
}

extension HankkiListViewController: UITableViewDelegate {
    
    /// 나의 족보 리스트
    /// 스와이프 해서 셀 지우기 설정
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
    
    /// 나의 족보 리스트
    /// 헤더의 스크롤 막기
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && self.type == .myZip {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }
    
    /// 터치시 식당 디테일로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: - navigation 연결
        print(indexPath.item, "번째 셀의 식당 디테일 뷰로 이동")
    }
}

extension HankkiListViewController: HankkiListTableViewCellDelegate {
    
    /// 하트 버튼 눌렀을 때
    func heartButtonDidTap(in cell: HankkiListTableViewCell, isSelected: Bool) {
        if let indexPath = hankkiTableView.indexPath(for: cell) {
            if isSelected {
                print(indexPath.item, "번째 식당을 삭제합니다.")
            } else {
                print(indexPath.item, "번째 식당을 추가합니다.")
            }
            viewModel.hankkiList[indexPath.item].isDeleted.toggle()
        }
    }
}

private extension HankkiListViewController {
    /// 셀을 지우는 함수
    func deleteItem(at indexPath: IndexPath) {
        viewModel.hankkiList.remove(at: indexPath.row)
        
        hankkiTableView.beginUpdates()
        hankkiTableView.deleteRows(at: [indexPath], with: .automatic)
        hankkiTableView.endUpdates()
    }
}

extension HankkiListViewController {
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
