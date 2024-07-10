//
//  ReportViewController.swift
//  Hankkijogbo
//
//  Created by 서은수 on 7/9/24.
//

import UIKit
import PhotosUI

final class ReportViewController: BaseViewController {
    
    // MARK: - Properties
    
    var isImageSet: Bool = false
    var image: UIImage?

    /// 다 임의로 넣어둠
    let dummyCategory = ["한식", "분식", "중식", "일식", "간편식", "패스트푸드", "양식", "샐러드/샌드위치", "세계음식"]
    let dummyHeader = ["식당 종류를 알려주세요", "메뉴를 추가해주세요"]
    let dummyMenu = ["", ""]
    
    // MARK: - UI Properties
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = ReportCompositionalFactory.create()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
    private let reportButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    override func setupHierarchy() {
        view.addSubviews(
            collectionView,
            reportButton
        )
    }
    
    override func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reportButton.snp.top).offset(-20)
        }
        reportButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(50)
        }
    }
    
    override func setupStyle() {
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .white
        }
        reportButton.do {
            $0.setAttributedTitle(UILabel.setupAttributedText(
                for: PretendardStyle.subtitle3,
                withText: "제보하기",
                color: .hankkiWhite
            ), for: .normal)
            $0.backgroundColor = .hankkiRed
            $0.layer.cornerRadius = 16
        }
    }
}

private extension ReportViewController {
    
    // MARK: - Private Func
    
    func setupRegister() {
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.className)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
        collectionView.register(SelectImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectImageCollectionViewCell.className)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.className)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.className)
        collectionView.register(AddMenuCollectionViewCell.self, forCellWithReuseIdentifier: AddMenuCollectionViewCell.className)
        collectionView.register(
            ReportHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ReportHeaderView.className
        )
    }
    
    func setupNavigationBar() {
        // TODO: - 백버튼 액션
        // TODO: - 네비 타이틀 폰트 설정
        let type: HankkiNavigationType = HankkiNavigationType(hasBackButton: true,
                                                              hasRightButton: true,
                                                              mainTitle: .string("제보하기"),
                                                              rightButton: .string(""),
                                                              rightButtonAction: {})
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}

private extension ReportViewController{
    
    // MARK: - @objc
    
    @objc func selectImageButtonDidTap() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func imageXButtonDidTap() {
        isImageSet = false
        self.collectionView.reloadSections(IndexSet(integer: ReportSectionType.image.rawValue))
    }
}

// MARK: - UICollectionView Delegate

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ReportHeaderView.className,
                for: indexPath
              ) as? ReportHeaderView else {
            return UICollectionReusableView()
        }
        header.dataBind(dummyHeader[indexPath.section - 1])
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = ReportSectionType(rawValue: section)
        switch sectionType {
        case .search, .image, .addMenu:
            return 1
        case .category:
            return dummyCategory.count
        case .menu:
            return dummyMenu.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = ReportSectionType(rawValue: indexPath.section)

        switch sectionType {
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .category:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(dummyCategory[indexPath.row])
            return cell
        case .image:
            if isImageSet {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.className, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
                cell.changeImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
                cell.selectedImageView.image = image
                cell.xButton.addTarget(self, action: #selector(imageXButtonDidTap), for: .touchUpInside)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectImageCollectionViewCell.className, for: indexPath) as? SelectImageCollectionViewCell else { return UICollectionViewCell() }
                cell.selectImageButton.addTarget(self, action: #selector(selectImageButtonDidTap), for: .touchUpInside)
                return cell
            }
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.className, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .addMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMenuCollectionViewCell.className, for: indexPath) as? AddMenuCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ReportViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        let itemProvider = results.first?.itemProvider // 2
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in // 4
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.isImageSet = true
                        self.image = image
                        self.collectionView.reloadSections(IndexSet(integer: ReportSectionType.image.rawValue))
                    } else {
                        self.isImageSet = false
                    }
                }
            }
        }
    }
}
