import UIKit
import Then

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 생성
        let button = UIButton(type: .system)
        button.setTitle("Show Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
        // 버튼 레이아웃 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showAlert() {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.do {
            $0.image = "2"
            $0.titleText = "변동사항을 알려주셔서 감사합니다 :)\n저렴하고 든든한 식사하세요!"
            $0.subText = "정말 로그아웃 하실 건가요?"
            
            $0.secondaryButtonText = "돌아가기"
            $0.primaryButtonText = "로그아웃"

        }
        self.present(alert, animated: false, completion: nil)
    }
}


