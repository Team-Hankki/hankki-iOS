//
//  ZipDetailViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/20/24.
//

import UIKit

final class ZipDetailViewController: BaseHankkiListViewController {
    
    // MARK: - Properties
    
    private let type: ZipDetailCollectionViewType
    private let zipId: Int
    private var isHeaderSetting: Bool = false
    private let headerViewHeight: CGFloat = UIView.convertByAspectRatioHeight(UIScreen.getDeviceWidth() - 22 * 2,
                                                                              width: 329,
                                                                              height: 231) + 22
    private let footerViewHeight: CGFloat = 112
    
    // MARK: - UI Components
    
    private lazy var bottomButtonView: BottomButtonView = BottomButtonView(primaryButtonText: StringLiterals.SharedZip.addButton,
                                                                           primaryButtonHandler: presentAddZipViewController,
                                                                           isPrimaryButtonAble: true)
    
    // MARK: - Life Cycle
    init (zipId: Int, type: ZipDetailCollectionViewType = .myZip) {
        self.type = type
        self.zipId = zipId
        super.init()
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
        
        switch type {
        case .myZip:
            viewModel.getZipDetail(zipId: zipId)
        case .sharedZip:
            viewModel.getSharedZipDetail(zipId: zipId)
            checkLogin()
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
                headerView.dataBind(self?.viewModel.zipInfo ?? nil, viewModel: self!.viewModel, isShareButtonHidden: self?.type == .sharedZip)
                self?.isHeaderSetting = true
            }
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        if type.isAddZipButton {
            view.addSubview(bottomButtonView)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        emptyView.snp.remakeConstraints {
            $0.centerY.equalTo(headerViewHeight + (UIScreen.getDeviceHeight() - headerViewHeight) / 2)
            $0.centerX.equalToSuperview()
        }
        
        if type.isAddZipButton {
            bottomButtonView.snp.makeConstraints {
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(154)
            }
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
        let request: DeleteZipToHankkiRequestDTO = DeleteZipToHankkiRequestDTO(favoriteId: zipId, storeId: viewModel.hankkiList[indexPath.item].id)
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
    
    // 공유 받은 족보 -> 족보 저장 뷰
    func presentAddZipViewController() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController {
            let addZipViewController = CreateZipViewController(isBottomSheetOpen: false, zipId: zipId, type: .sharedZip)
            rootViewController.pushViewController(addZipViewController, animated: true)
        }
    }
    
    /// 로그인 여부 확인
    /// 비로그인 회원인 경우, 로그인 필요 경고를 띄운뒤 로그인 뷰로 이동한다
    func checkLogin() {
        if !UserDefaults.standard.isLogin {
            self.showAlert(titleText: StringLiterals.Alert.NeedLoginToSharedZip.title,
                           primaryButtonText: StringLiterals.Alert.NeedLoginToSharedZip.primaryButton,
                           primaryButtonHandler: UIApplication.resetApp)
        }
    }
}
// MARK: - Delegat

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
        if type == .sharedZip {
            return nil
        }
        
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
        if type == .sharedZip {
            return 100
        }
        
        if viewModel.hankkiList.isEmpty {
            return 0
        }
        
        return footerViewHeight
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
        if scrollView.contentOffset.y < 0 {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .myZip {
            super.tableView(tableView, didSelectRowAt: indexPath)
        } else {
            return
        }
    }
}
