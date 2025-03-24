//
//  ShareWithSheetViewController.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 24/03/25.
//

import UIKit
import SwiftUI

class ShareWithSheetViewController: UIViewController {
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        configureVC()
    }

    var usersList: [User] = []

    private func setupNavBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance ?? .none

        title = "Share with"
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.separatorStyle = .none
        tableView.register(HomeListCell.self, forCellReuseIdentifier: String(describing: HomeListCell.self))
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureVC() {
        self.usersList = HomeInteractor(intentService: IntentService()).listUsers()
    }

    private func setupView() {
        setupTableView()
    }
}


extension ShareWithSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListCell.self), for: indexPath) as? HomeListCell else {
            fatalError("Cell not available")
        }
        let user: User = usersList[indexPath.row]
        cell.configure(title: user.title, subtitle: "", showCheckBox: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? HomeListCell {
            cell.toggleCheckBox()
        }
    }
}

struct ShareWithListView: View {
    var body: some View {
        ViewControllerPreview(viewController: ShareWithSheetViewController())
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareWithListView()
    }
}
