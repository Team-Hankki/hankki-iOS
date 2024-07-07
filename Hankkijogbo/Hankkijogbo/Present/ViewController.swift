//
//  ViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

import SnapKit
import Then

class ViewController: UIViewController {
    
    let toastMessage = WhiteToastView(message: "나의 족보에 추가했어요") {
        print("나의 족보 화면으로 이동해야 함")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}
