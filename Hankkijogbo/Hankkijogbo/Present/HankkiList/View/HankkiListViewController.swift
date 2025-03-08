//
//  HankkiListViewController.swift
//  Hankkijogbo
//
//  Created by 심서현 on 12/20/24.
//

import UIKit

final class HankkiListViewController: BaseHankkiListViewController {
    
    // MARK: - Properties
    
    private let type: HankkiListViewControllerType
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    init(_ type: BaseHankkiListViewController.HankkiListViewControllerType) {
        self.type = type
        super.init()
        
        self.emptyView = EmptyView(text: type.emptyViewLabel)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        if type == .liked && !viewModel.hankkiList.isEmpty {
            viewModel.updateMeHankkiList()
            return
        }
        viewModel.getMeHankkiList(type.userTargetType)
    }
}

private extension HankkiListViewController {
    
    func setupNavigationBar() {
        let type: HankkiNavigationType
        
        type = HankkiNavigationType(
            hasBackButton: true,
            hasRightButton: false,
            mainTitle: .string(self.type.navigationTitle),
            rightButton: .string(""),
            rightButtonAction: {},
            backgroundColor: UIColor.hankkiWhite
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func deleteLike(_ id: Int) {
        viewModel.deleteHankkiHeart(id: id)
    }
    
    func postLike(_ id: Int) {
        viewModel.postHankkiHeart(id: id)
    }
}

extension HankkiListViewController {
    
    // 헤더 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // 푸터 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // cell data bind
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HankkiListTableViewCell.className,
                                                       for: indexPath
        ) as? HankkiListTableViewCell else { return UITableViewCell() }
        
        if type == .liked {
            cell.dataBind(viewModel.hankkiList[indexPath.item],
                          isFinal: viewModel.hankkiList.count - 1 == indexPath.item,
                          isLikeButtonDisable: false)
            cell.delegate = self
            
            return cell
        } else {
            cell.dataBind(viewModel.hankkiList[indexPath.item],
                          isFinal: viewModel.hankkiList.count - 1 == indexPath.item)
            return cell
        }
    }

    /// 터치시 식당 디테일로 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hankkiId = viewModel.hankkiList[indexPath.item].id
        pushToDetailWithHankkiNavigation(hankkiId: hankkiId)
    }
}

extension HankkiListViewController: HankkiListTableViewCellDelegate {
    
    /// 하트 버튼 눌렀을 때
    func heartButtonDidTap(in cell: HankkiListTableViewCell, isSelected: Bool) {
        var calc: Int = 1
        if let indexPath = hankkiTableView.indexPath(for: cell) {
            let hankkiId: Int = viewModel.hankkiList[indexPath.item].id
            if isSelected {
                calc *= -1
                deleteLike(hankkiId)
                
            } else {
                postLike(hankkiId)
            }
            let currendData: HankkiListTableViewCell.Model = viewModel.hankkiList[indexPath.item]
            let newData: HankkiListTableViewCell.Model = HankkiListTableViewCell.Model(
                id: currendData.id,
                name: currendData.name,
                imageURL: currendData.imageURL,
                category: currendData.category,
                lowestPrice: currendData.lowestPrice,
                heartCount: currendData.heartCount + calc,
                isDeleted: !currendData.isDeleted
            )
            
            viewModel.hankkiList[indexPath.item] = newData
        }
    }
}
