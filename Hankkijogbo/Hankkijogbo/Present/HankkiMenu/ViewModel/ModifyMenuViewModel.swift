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
    var selectedMenu: SelectableMenuData
    
    init(storeId: Int, selectedMenu: SelectableMenuData) {
        self.storeId = storeId
        self.selectedMenu = selectedMenu
    }
}

extension ModifyMenuViewModel {
    
    /// 메뉴 수정
    func modifyMenuAPI(completion: @escaping () -> Void) {
        let requestBody: PatchMenuRequestDTO = PatchMenuRequestDTO(name: selectedMenu.name, price: selectedMenu.price)
        NetworkService.shared.menuService.patchMenu(storeId: storeId, id: selectedMenu.id, requestBody: requestBody) { result in
            result.handleNetworkResult { _ in completion() }
        }
    }
}
