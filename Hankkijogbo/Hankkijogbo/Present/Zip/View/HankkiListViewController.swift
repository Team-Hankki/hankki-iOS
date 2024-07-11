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
    
    private var dummyHankkiList: [HankkiListTableViewCell.DataStruct] = [
        HankkiListTableViewCell.DataStruct(id: 1, name: "짜장면", imageURL: "dummy.png", category: "중식", lowestPrice: 1200, heartCount: 100),
        HankkiListTableViewCell.DataStruct(id: 2, name: "동민오빠의 김치말이 국수", imageURL: "dummy.png", category: "한식", lowestPrice: 6000, heartCount: 200),
        HankkiListTableViewCell.DataStruct(id: 3, name: "록가정식", imageURL: "dummy.png", category: "한식", lowestPrice: 6000, heartCount: 300),
        HankkiListTableViewCell.DataStruct(id: 4, name: "김가현의 어묵 볶음", imageURL: "dummy.png", category: "아요식", lowestPrice: 8000, heartCount: 400),
        HankkiListTableViewCell.DataStruct(id: 5, name: "배떡", imageURL: "dummy.png", category: "분식", lowestPrice: 18000, heartCount: 6),
        HankkiListTableViewCell.DataStruct(id: 6, name: "록주언니의 종합 볶음 밥", imageURL: "dummy7", category: "밥", lowestPrice: 12345, heartCount: 123),
        HankkiListTableViewCell.DataStruct(id: 7, name: "매밀 전병", imageURL: "dummy.png", category: "간식", lowestPrice: 1230, heartCount: 134),
        HankkiListTableViewCell.DataStruct(id: 1, name: "짜장면", imageURL: "dummy.png", category: "중식", lowestPrice: 1200, heartCount: 100),
        HankkiListTableViewCell.DataStruct(id: 2, name: "동민오빠의 김치말이 국수", imageURL: "dummy.png", category: "한식", lowestPrice: 6000, heartCount: 200),
        HankkiListTableViewCell.DataStruct(id: 3, name: "록가정식", imageURL: "dummy.png", category: "한식", lowestPrice: 6000, heartCount: 300),
        HankkiListTableViewCell.DataStruct(id: 4, name: "김가현의 어묵 볶음", imageURL: "dummy.png", category: "아요식", lowestPrice: 8000, heartCount: 400),
        HankkiListTableViewCell.DataStruct(id: 5, name: "배떡", imageURL: "dummy.png", category: "분식", lowestPrice: 18000, heartCount: 6),
        HankkiListTableViewCell.DataStruct(id: 6, name: "록주언니의 종합 볶음 밥", imageURL: "dummy7", category: "밥", lowestPrice: 12345, heartCount: 123),
        HankkiListTableViewCell.DataStruct(id: 7, name: "매밀 전병", imageURL: "dummy.png", category: "간식", lowestPrice: 1230, heartCount: 134)
    ]
    
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
    
    /// 셀을 지우는 함수
    func deleteItem(at indexPath: IndexPath) {
        dummyHankkiList.remove(at: indexPath.row)
        
        hankkiTableView.beginUpdates()
        hankkiTableView.deleteRows(at: [indexPath], with: .automatic)
        hankkiTableView.endUpdates()
    }
}

extension HankkiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyHankkiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HankkiListTableViewCell.className,
            for: indexPath
        ) as? HankkiListTableViewCell else { return UITableViewCell() }
        
        cell.dataBind(dummyHankkiList[indexPath.item], isLikeButtonDisable: self.type != .liked)
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: - navigation 연결
        print(indexPath.item, "번째 셀의 식당 디테일 뷰로 이동")
    }
}

extension HankkiListViewController: HankkiListTableViewCellDelegate {
    func heartButtonDidTap(in cell: HankkiListTableViewCell, isSelected: Bool) {
        if let indexPath = hankkiTableView.indexPath(for: cell) {
            if isSelected {
                print(indexPath.item, "번째 식당을 삭제합니다.")
            } else {
                print(indexPath.item, "번째 식당을 추가합니다.")
            }
        }
    }
}
