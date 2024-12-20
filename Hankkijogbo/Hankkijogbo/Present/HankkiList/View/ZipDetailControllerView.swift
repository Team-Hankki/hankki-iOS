//
//  ZipDetailControllerView.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/20/24.
//

import UIKit

final class ZipDetailViewController: BaseHankkiListViewController {
    
    // MARK: - Properties
    
    private let zipID: Int
    private var isHeaderSetting: Bool = false
    private let headerViewHeight: CGFloat = UIView.convertByAspectRatioHeight(UIScreen.getDeviceWidth() - 22 * 2,
                                                                              width: 329,
                                                                              height: 231) + 22
    
    // MARK: - Life Cycle
    init (zipID: Int, type: HankkiListViewControllerType = .myZip) {
        self.zipID = zipID
        super.init(type)
        self.emptyView = EmptyView(
            text: StringLiterals.HankkiList.EmptyView.myZip,
            buttonText: StringLiterals.HankkiList.moreButton,
            buttonAction: self.navigateToHomeView
        )
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        if type == .myZip {
            viewModel.getZipDetail(zipID: zipID)
        }
    }
    
    // MARK: - override
    override func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.emptyView.isHidden = (self?.viewModel.hankkiList.count != 0)
                self?.hankkiTableView.reloadData()
            }
            
            if !(self?.isHeaderSetting ?? false) {
                guard let headerView = self?.hankkiTableView.headerView(forSection: 0) as? ZipHeaderTableView else { return }
                headerView.dataBind(self?.viewModel.zipInfo ?? nil, viewModel: self!.viewModel)
                self?.isHeaderSetting = true
            }
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        emptyView.snp.remakeConstraints {
            $0.centerY.equalTo(headerViewHeight + (UIScreen.getDeviceHeight() - headerViewHeight) / 2)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension ZipDetailViewController {
    
    func setupNavigationBar() {
        let type: HankkiNavigationType
        
        type = HankkiNavigationType(
            hasBackButton: true,
            hasRightButton: false,
            mainTitle: .string(self.type.navigationTitle),
            rightButton: .string(""),
            rightButtonAction: {},
            backgroundColor: UIColor.red500
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    /// 셀을 지우는 함수
    func deleteItem(at indexPath: IndexPath) {
        let request: DeleteZipToHankkiRequestDTO = DeleteZipToHankkiRequestDTO(favoriteId: zipID, storeId: viewModel.hankkiList[indexPath.item].id)
        viewModel.deleteZipToHankki(requestBody: request) {
            self.removeCellFromCollectionView(indexPath)
        }
    }
    
    func removeCellFromCollectionView(_ indexPath: IndexPath) {
        viewModel.hankkiList.remove(at: indexPath.row)
        
        hankkiTableView.beginUpdates()
        hankkiTableView.deleteRows(at: [indexPath], with: .automatic)
        hankkiTableView.endUpdates()
    }
}
// MARK: - Delegate UITableView
extension ZipDetailViewController {
    
    /// 헤더 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ZipHeaderTableView.className
        )
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight
    }
    
    /// 푸터 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.hankkiList.isEmpty {
            return nil
        }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ZipFooterTableView.className
        ) as? ZipFooterTableView ?? ZipFooterTableView(reuseIdentifier: ZipFooterTableView.className)
        footerView.viewController = self
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.hankkiList.isEmpty {
            return 0
        }
        
        return 112
    }
    
    /// 스와이프 해서 셀 지우기 설정
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.type != .myZip {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            self.deleteItem(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red500
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    /// 헤더의 스크롤 막기
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && self.type == .myZip {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }
}
