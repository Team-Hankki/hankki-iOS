//
//  DropDownView.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/11/24.
//

import UIKit

protocol DropDownViewDelegate: AnyObject {
    func dropDownView(_ controller: DropDownView, didSelectItem item: String, buttonType: ButtonType)
}

final class DropDownView: BaseView {
    
    // MARK: - Properties
    
    weak var delegate: DropDownViewDelegate?
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
        tableView.layer.cornerRadius = 10
    }
    
    init(isPriceModel: Bool, buttonType: ButtonType) {
        self.buttonType = buttonType
        if isPriceModel {
            self.numberOfCells = dataPrice.count
            self.data = dataPrice.map { $0.amount }
        } else {
            self.numberOfCells = dataSort.count
            self.data = dataSort.map { $0.sortType }
        }
        
        print(data, "❤️")
        super.init(frame: .zero)
        
        setupDelegate()
        setupRegister()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DropDownView {
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

extension DropDownView:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .setupPretendardStyle(of: .caption1)
        cell.textLabel?.textColor = .gray600
        cell.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDownView(self, didSelectItem: data[indexPath.row], buttonType: buttonType)
    }
}
