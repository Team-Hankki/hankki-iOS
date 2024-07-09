//
//  HomeView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 2024/06/21.
//
import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Properties
    
    private let buttonType = ["종류", "가격대", "정렬"]
    
    // MARK: - UI Components
    
    var mapView = NMFMapView()
    
    let typeButton = UIButton()
    let priceButton = UIButton()
    let sortButton = UIButton()
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        addSubviews(mapView, 
                    typeButton,
                    priceButton,
                    sortButton)
    }
    
    override func setupLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typeButton.snp.makeConstraints {
            $0.top.leading.equalTo(mapView).inset(22)
            $0.width.equalTo(61)
            $0.height.equalTo(32)
        }
        
        priceButton.snp.makeConstraints {
            $0.top.equalTo(typeButton.snp.top)
            $0.leading.equalTo(typeButton.snp.trailing).offset(8)
            $0.width.equalTo(72)
            $0.height.equalTo(32)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(typeButton.snp.top)
            $0.leading.equalTo(priceButton.snp.trailing).offset(8)
            $0.width.equalTo(61)
            $0.height.equalTo(32)
        }
        
    }
    
    override func setupStyle() {
        let buttons = [typeButton, priceButton, sortButton]
        for (index, button) in buttons.enumerated() {
            button.do {
                $0.backgroundColor = .white
                $0.makeRoundBorder(cornerRadius: 16, borderWidth: 1, borderColor: .gray300)
                $0.setTitle(buttonType[index], for: .normal)
                $0.setTitleColor(.gray400, for: .normal)
                $0.setImage(.icArrow, for: .normal)
                $0.titleLabel?.font = .setupPretendardStyle(of: .caption1)
                $0.contentHorizontalAlignment = .left
                $0.semanticContentAttribute = .forceRightToLeft
                $0.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
            }
        }
    }
}

private extension HomeView {
    
    func setupAddTarget() {
        let buttons = [typeButton, priceButton, sortButton]
        for button in buttons {
            button.addTarget(self, action: #selector(actionButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc func actionButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateButtonStyle(sender)
    }
    
    // TODO: - SVG 파일로 변경 후 button image 변경
    func updateButtonStyle(_ button: UIButton) {
        if button.isSelected {
            button.setTitleColor(.gray600, for: .normal)
            button.setImage(.icArrow.withTintColor(.black), for: .normal)
        } else {
            button.setTitleColor(.gray400, for: .normal)
            button.setImage(.icArrow, for: .normal)
        }
    }
}
