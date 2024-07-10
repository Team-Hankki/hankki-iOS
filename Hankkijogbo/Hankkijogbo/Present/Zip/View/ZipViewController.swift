import UIKit

final class ZipViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private lazy var hankkiTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupDelegate()
    }
    
    // MARK: - setup UI
    
    override func setupStyle() {
        hankkiTableView.do {
            $0.isEditing = false
            $0.bounces = true
            $0.alwaysBounceVertical = true
        }
    }
    
    override func setupHierarchy() {
        view.addSubviews(hankkiTableView)
    }
    
    override func setupLayout() {
        hankkiTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension ZipViewController {
    func setupRegister() {
        hankkiTableView.register(ZipHeaderTableView.self, forHeaderFooterViewReuseIdentifier: ZipHeaderTableView.className)
        hankkiTableView.register(HankkiTableViewCell.self, forCellReuseIdentifier: HankkiTableViewCell.className)
    }
    
    func setupDelegate() {
        hankkiTableView.delegate = self
        hankkiTableView.dataSource = self
    }
    
    func setupNavigationBar() {
        let type: HankkiNavigationType
        
        type = HankkiNavigationType(
            hasBackButton: true,
            hasRightButton: false,
            mainTitle: .string("식당족보"),
            rightButton: .string(""),
            rightButtonAction: {},
            backgroundColor: .hankkiRed
        )
        
        if let navigationController = navigationController as? HankkiNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
     }
}

extension ZipViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HankkiTableViewCell.className,
            for: indexPath
        ) as? HankkiTableViewCell else { return UITableViewCell() }
        
        cell.dataBind()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ZipHeaderTableView.className
        )
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIView.convertByAspectRatioHeight(UIScreen.getDeviceWidth() - 22 * 2, width: 329, height: 231) + 22
    }
}

extension ZipViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HankkiTableViewCell else { return }
        cell.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            print(action)
            print(view)
            print("삭제시작")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .hankkiRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.bounces = false
        } else {
            scrollView.bounces = true
        }
    }

}
