//
//  HomeViewController.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit
import SwiftUI

protocol HomeViewProtocol: AnyObject {
    var viewController: UIViewController { get }
    func showList(_ list: [User])
}

class HomeViewController: UIViewController {
    let presenter: HomePresenterProtocol

    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var usersList: [User] = []

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        configureVC()
    }

    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = UIColor.systemTeal
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundColor = UIColor.systemTeal
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        title = "Users"
    }

    private func configureVC() {
        presenter.refresh()
    }

    private func setupView() {
        setupTableView()
    }
}

extension HomeViewController {

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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.configure(title: user.title, subtitle: "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersList[indexPath.row]
        presenter.donateIntent(for: user)
        print("User tapped: \(user.title)")
    }
}

extension HomeViewController: HomeViewProtocol {
    var viewController: UIViewController {
        self
    }

    func showList(_ list: [User]) {
        DispatchQueue.main.async {
            self.usersList = list
            self.tableView.reloadData()
        }
    }
}

struct HomeView: View {
    var body: some View {
        ViewControllerPreview(viewController: HomeRouter.createModule())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
