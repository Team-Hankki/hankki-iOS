//
//  DropDownViewController.swift
//  Hankkijogbo
//
//  Created by Gahyun Kim on 7/11/24.
//

import UIKit
import SnapKit
import Then

final class DropDownViewController: BaseView {
    
    // MARK: - Properties
    
    private var numberOfCells: Int = 0
    private var tableView = UITableView()
    
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
    
    init(numberOfCells: Int) {
        self.numberOfCells = numberOfCells
        super.init(frame: .zero)
     //    setupView()
        
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
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Cell \(indexPath.row + 1)")
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
