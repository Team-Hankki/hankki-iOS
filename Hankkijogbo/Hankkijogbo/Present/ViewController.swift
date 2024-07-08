//
//  ViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 알림 버튼 추가
        let alertButton = UIButton(type: .system)
        alertButton.setTitle("Show Alert", for: .normal)
        alertButton.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(alertButton)
        
        // 버튼 제약 조건 설정
        NSLayoutConstraint.activate([
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showAlertButtonTapped() {
        showAlert(
            image: "alertIcon", // 여기에 이미지 이름을 입력하세요
            titleText: "Alert Title\nline2",
            subText: "This is a subtitle for the alert.",
            secondaryButtonText: "Cancel",
            primaryButtonText: "OK",
            secondaryButtonHandler: {
                print("Secondary button tapped")
            },
            primaryButtonHandler: {
                print("Primary button tapped")
            }
        )
    }
}
