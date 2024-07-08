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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showBlackToast(message: "나의 족보에 추가되었습니다.") {
            print("zz")
        }
        showWhiteToast(message: "내 족보에 추가했어요") {
            print("xx")
        }
    }
}
