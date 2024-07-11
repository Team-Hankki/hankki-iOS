//
//  DropDownViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/11/24.
//

import UIKit

protocol DropDownViewControllerDelegate: AnyObject {
   // func testfunction()
    func dropDownViewController(_ controller: DropDownViewController, didSelectItem item: String, buttonType: ButtonType)
}

final class DropDownViewController: BaseView {
    
    // MARK: - Properties
    
    weak var delegate: DropDownViewControllerDelegate?
    private var buttonType: ButtonType
    
    private var numberOfCells: Int = 0
    var tableView = UITableView()
    
    private let dataPrice = dummyPrice
    private let dataSort = dummySort
    private var data: [String] = []
    
    // MARK: - Life Cycle
    
    override func setupHierarchy() {
        addSubview(tableView)
    }
    
    override func setupLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupStyle() {
        
    }
    
//    init(isPriceModel: Bool) {
//        if isPriceModel {
//            self.numberOfCells = dataPrice.count
//            print(numberOfCells,"💞")
//             self.data = dataPrice.map { $0.amount }
//        } else {
//            self.numberOfCells = dataSort.count
//            print(numberOfCells, "💞💞")
//             self.data = dataSort.map { $0.sortType }
//        }
//        super.init(frame: .zero)
//        
//        setupDelegate()
//        setupRegister()
//        
//    }
    init(isPriceModel: Bool, buttonType: ButtonType) {
            self.buttonType = buttonType
            if isPriceModel {
                self.numberOfCells = dataPrice.count
                self.data = dataPrice.map { $0.amount } // amount 필드를 사용하는 것으로 가정
            } else {
                self.numberOfCells = dataSort.count
                self.data = dataSort.map { $0.sortType } // sortType 필드를 사용하는 것으로 가정
            }
            super.init(frame: .zero)
            
            setupDelegate()
            setupRegister()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DropDownViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("123123")
       // delegate?.testfunction()
        print(indexPath.item)
//        delegate?.dropDownViewController(self, didSelectItem: data[indexPath.item])
        delegate?.dropDownViewController(self, didSelectItem: data[indexPath.row], buttonType: buttonType)
    }
    
}

extension DropDownViewController {
    
    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupRegister() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateNumberOfCells(_ count: Int) {
        self.numberOfCells = count
        tableView.reloadData()
    }
}


extension DropDownViewController {
    
}
