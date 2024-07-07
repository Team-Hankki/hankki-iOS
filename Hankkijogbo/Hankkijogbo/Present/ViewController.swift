import UIKit
import Then

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 첫 번째 버튼 생성
        let button1 = UIButton(type: .system)
        button1.setTitle("show image alert", for: .normal)
        button1.addTarget(self, action: #selector(button1DidTapped), for: .touchUpInside)
        
        // 두 번째 버튼 생성
        let button2 = UIButton(type: .system)
        button2.setTitle("show text alert", for: .normal)
        button2.addTarget(self, action: #selector(button2DidTapped), for: .touchUpInside)
        
        // 버튼 레이아웃 설정
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button1)
        view.addSubview(button2)
        
        NSLayoutConstraint.activate([
            // 첫 번째 버튼 레이아웃
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            // 두 번째 버튼 레이아웃
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        ])
    }
    
    @objc func button1DidTapped() {
        self.showAlert(
            image: "123",
            titleText: "헐! 대박\n내일 진짜 합숙이에요?",
            subText: "아직 짐을 하나도 안 챙겼어요\n준비 중이에요",
            
            primaryButtonText: "짐 싸기"
        )
    }
    
    @objc func button2DidTapped() {
        self.showAlert(
            titleText: "앱잼만을 기다렸어...\n한끼줍쇼 파이팅",
            subText: "진심이야~",
            secondaryButtonText: "낭만앱잼",
            primaryButtonText: "행복앱잼"
        )
    }
}
