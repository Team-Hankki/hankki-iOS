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
    var showAlert: ((String) -> Void)?
    
    var menus: [SelectableMenuData] = [] {
        didSet {
            updateCollectionView?()
        }
    }
    
    init(menus: [SelectableMenuData]) {
        self.menus = menus
    }
}

extension EditMenuViewModel {
    
    func disableSelectedMenus() {
        menus.enumerated().forEach { index, menu in
            if menu.isSelected {
                menus[index].isSelected = false
            }
        }
    }
    
    /// 메뉴 수정
    func modifyMenuAPI(storeId: Int, id: Int, requestBody: MenuData, completion: @escaping () -> Void) {
        NetworkService.shared.menuService.patchMenu(storeId: storeId, id: id, requestBody: requestBody) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
    
    /// 메뉴 삭제
    func deleteMenuAPI(storeId: Int, id: Int, completion: @escaping () -> Void) {
        NetworkService.shared.menuService.deleteMenu(storeId: storeId, id: id) { result in
            result.handleNetworkResult { _ in
                completion()
            }
        }
    }
}
