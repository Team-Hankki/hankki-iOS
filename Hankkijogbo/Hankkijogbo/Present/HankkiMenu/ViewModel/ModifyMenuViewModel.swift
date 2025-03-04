//
//  ModifyMenuViewModel.swift
//  Hankkijogbo
//
//  Created by 서은수 on 11/4/24.
//

import Moya

final class ModifyMenuViewModel {
    
    var updateButton: ((Bool) -> Void)?
    
    var storeId: Int
    var isLastMenu: Bool
    var selectedMenu: SelectableMenuData
    lazy var modifiedMenuData: MenuRequestDTO = MenuRequestDTO(name: selectedMenu.name, price: selectedMenu.price) {
        didSet {
            updateButton?(isMenuDataValid())
        }
    }
    
    init(storeId: Int, isLastMenu: Bool, selectedMenu: SelectableMenuData) {
        self.storeId = storeId
        self.isLastMenu = isLastMenu
        self.selectedMenu = selectedMenu
    }
}

extension ModifyMenuViewModel {
    
    func isMenuDataValid() -> Bool {
        return !(modifiedMenuData.name.isEmpty) && (modifiedMenuData.price > 0) && (modifiedMenuData.price <= 8000) && ((modifiedMenuData.name != selectedMenu.name) || (modifiedMenuData.price != selectedMenu.price))
    }
    
    /// 메뉴 수정
    func modifyMenuAPI(completion: @escaping () -> Void) {
        if isMenuDataValid() {
            NetworkService.shared.menuService.patchMenu(storeId: storeId, id: selectedMenu.id, requestBody: modifiedMenuData) { result in
                result.handleNetworkResult { _ in completion() }
            }
        }
    }
    
    /// 메뉴 삭제
    func deleteMenuAPI(completion: @escaping () -> Void) {
        NetworkService.shared.menuService.deleteMenu(storeId: storeId, id: selectedMenu.id) { result in
            result.handleNetworkResult(onSuccessVoid: completion)
            SetupAmplitude.shared.logEvent(AmplitudeLiterals.Detail.tabMenuDeleteCompleted)
        }
    }
}
