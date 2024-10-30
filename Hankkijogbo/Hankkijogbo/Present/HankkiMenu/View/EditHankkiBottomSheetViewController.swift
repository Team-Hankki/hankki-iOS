//
//  EditHankkiBottomSheetViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 10/1/24.
//

import UIKit

final class EditHankkiBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var storeId: Int
    private var defaultHeight: CGFloat = 295
    private var isHaveToDismiss: Bool = false
    private var selectableMenus: [SelectableMenuData]
    
    // MARK: - UI Components
    
    private let dimmedView: UIView = UIView()
    private let containerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let addNewMenuImageView: UIImageView = UIImageView()
    private let addNewMenuStackView: UIStackView = UIStackView()
    private let addNewMenuButton: UIButton = UIButton()
    private let addNewMenuLabel: UILabel = UILabel()
    private let modifyMenuImageView: UIImageView = UIImageView()
    private let modifyMenuStackView: UIStackView = UIStackView()
    private let modifyMenuButton: UIButton = UIButton()
    private let modifyMenuLabel: UILabel = UILabel()
    
    // MARK: - Init
    
    init(storeId: Int, selectableMenus: [SelectableMenuData]) {
        self.storeId = storeId
        self.selectableMenus = selectableMenus
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHaveToDismiss {
            self.dismiss(animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isHaveToDismiss = true
    }
    
    // MARK: - Set UI
    
    override func setupHierarchy() {
        view.addSubviews(dimmedView, containerView)
        containerView.addSubviews(
            titleLabel,
            addNewMenuImageView,
            modifyMenuImageView
        )
        addNewMenuImageView.addSubview(addNewMenuStackView)
        addNewMenuStackView.addArrangedSubviews(addNewMenuButton, addNewMenuLabel)
        modifyMenuImageView.addSubview(modifyMenuStackView)
        modifyMenuStackView.addArrangedSubviews(modifyMenuButton, modifyMenuLabel)
    }
    
    override func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        addNewMenuImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo((UIScreen.getDeviceWidth() - 58) / 2)
            $0.height.equalTo(154)
        }
        
        addNewMenuStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }
        
        modifyMenuImageView.snp.makeConstraints {
            $0.top.equalTo(addNewMenuImageView)
            $0.leading.equalTo(addNewMenuImageView.snp.trailing).offset(10)
            $0.width.height.equalTo(addNewMenuImageView)
        }
        
        modifyMenuStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }
    }
    
    override func setupStyle() {
        view.do {
            $0.backgroundColor = .clear
        }
        
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.67)
        }
        
        containerView.do {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 32
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        titleLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.h2,
                withText: StringLiterals.EditHankki.howToEdit,
                color: .gray900
            )
        }
        
        addNewMenuImageView.do {
            $0.isUserInteractionEnabled = true
            $0.image = .imgAdd
            $0.makeRoundBorder(cornerRadius: 20, borderWidth: 1, borderColor: .gray200)
        }
        
        addNewMenuStackView.do {
            $0.isUserInteractionEnabled = true
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 8
        }
        
        addNewMenuButton.do {
            $0.setImage(.icAddMenu, for: .normal)
        }
        addNewMenuLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.subtitle2,
                withText: StringLiterals.EditHankki.addNewMenu,
                color: .gray800
            )
            $0.numberOfLines = 2
        }
        
        modifyMenuImageView.do {
            $0.isUserInteractionEnabled = true
            $0.image = .imgEdit
            $0.makeRoundBorder(cornerRadius: 20, borderWidth: 1, borderColor: .gray200)
        }
        
        modifyMenuStackView.do {
            $0.isUserInteractionEnabled = true
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 8
        }
        
        modifyMenuButton.do {
            $0.setImage(.icEditMenu, for: .normal)
        }
        modifyMenuLabel.do {
            $0.attributedText = UILabel.setupAttributedText(
                for: SuiteStyle.subtitle2,
                withText: StringLiterals.EditHankki.modifyMenu,
                color: .gray800
            )
            $0.numberOfLines = 2
        }
    }
}

private extension EditHankkiBottomSheetViewController {
    
    // MARK: - Private Func
    
    func setupAddTarget() {
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap)))
        addNewMenuImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMenuDidTap)))
        addNewMenuLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMenuDidTap)))
        addNewMenuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMenuDidTap)))
        modifyMenuImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyMenuDidTap)))
        modifyMenuLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyMenuDidTap)))
        modifyMenuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyMenuDidTap)))
    }
    
    // MARK: - @objc
    
    @objc func dimmedViewDidTap() {
        dismissMyZipBottomSheet()
    }
    
    @objc func addNewMenuDidTap() {
        let addMenuViewController = AddMenuViewController(storeId: storeId)
        self.navigationController?.pushViewController(addMenuViewController, animated: true)
    }
    
    @objc func modifyMenuDidTap() {
        let editMenuViewController = EditMenuViewController(viewModel: EditMenuViewModel(menus: selectableMenus))
        self.navigationController?.pushViewController(editMenuViewController, animated: true)
    }
}

extension EditHankkiBottomSheetViewController {
    
    func dismissMyZipBottomSheet() {
        containerView.snp.remakeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func viewLayoutIfNeededWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
    }
}
