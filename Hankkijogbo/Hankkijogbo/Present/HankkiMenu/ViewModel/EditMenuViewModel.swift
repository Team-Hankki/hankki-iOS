//
//  EditMenuViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/11/24.
//

import Moya

final class EditMenuViewModel {
    
    var updateCollectionView: (() -> Void)?
    var updateButton: ((Bool) -> Void)?
    
    var storeId: Int
    var menus: [SelectableMenuData] = [] {
        didSet {
            updateSelectedMenu()
            updateCollectionView?()
        }
    }
    var selectedMenu: SelectableMenuData? {
        didSet {
            updateButton?(selectedMenu != nil)
        }
    }
    
    init(storeId: Int, menus: [SelectableMenuData]) {
        self.storeId = storeId
        self.menus = menus
    }
}

extension EditMenuViewModel {
    
    func updateSelectedMenu() {
        selectedMenu = menus.filter { $0.isSelected }.first
    }
    
    func disableSelectedMenus() {
        menus.enumerated().forEach { index, menu in
            if menu.isSelected {
                menus[index].isSelected = false
            }
        }
    }
    
    /// 메뉴 삭제
    func deleteMenuAPI(completion: @escaping () -> Void) {
        guard let selectedMenu = selectedMenu else { return }
        NetworkService.shared.menuService.deleteMenu(storeId: storeId, id: selectedMenu.id) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
        }
    }
    
    /// 식당 상세 쪽에서 메뉴 가져오기 -> 일단 임시로 사용 중...
    func getUpdatedMenusAPI(completion: @escaping () -> Void) {
        NetworkService.shared.hankkiService.getHankkiDetail(id: storeId) { [weak self] result in
            result.handleNetworkResult { response in
                self?.menus = response.data.menus.map {
                    SelectableMenuData(
                        isSelected: false,
                        id: $0.id,
                        name: $0.name,
                        price: $0.price
                    )
                }
                completion()
            }
        }
    }
}
