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
    
    private let viewModel: HomeViewModel
    
    weak var delegate: DropDownViewDelegate?
    private var buttonType: ButtonType
    
    private var numberOfCells: Int = 0
    var tableView = UITableView()
    
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
        tableView.makeRounded(radius: 10)
    }
    
    init(isPriceModel: Bool, buttonType: ButtonType, viewModel: HomeViewModel) {
        self.buttonType = buttonType
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupDelegate()
        setupRegister()
        
        if isPriceModel {
            viewModel.getPriceCategoryFilterAPI { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.numberOfCells = self.viewModel.priceFilters.count
                    self.data = self.viewModel.priceFilters.map { $0.name }
                    self.updateTableView()
                    self.updateDropDownConstraints()
                }
            }
        } else {
            viewModel.getSortOptionFilterAPI { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.numberOfCells = self.viewModel.sortOptions.count
                    self.data = self.viewModel.sortOptions.map { $0.name }
                    self.updateTableView()
                    self.updateDropDownConstraints()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func updateDropDownConstraints() {
        DispatchQueue.main.async {
            self.snp.updateConstraints {
                let height = self.numberOfCells * 44
                $0.height.equalTo(height)
            }
            self.superview?.layoutIfNeeded()
        }
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
}

extension DropDownView: UITableViewDelegate, UITableViewDataSource {
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
