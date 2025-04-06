//
//  FilterViewController.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 25/03/25.
//

import UIKit
import SwiftUI

protocol FilterViewControllerDelegate: AnyObject {
    func rowSelected(indexPath: IndexPath, filter: FilterModel)
    func resetFilters()
}

protocol FilterViewControllerProtocol {
    var filters: [FilterModel] { get set }
    func updateFilters(_ filters: [FilterModel])
    func reloadData()
    func reloadSection(at indexPath: IndexPath, filterModel: FilterModel)
}
struct FilterModel: Equatable {
    var isSelected: Bool {
        return suboptions.filter( \.isSelected ).isEmpty == false
    }

    var title: String
    var isOpened: Bool
    var suboptions: [Suboption]

    struct Suboption: Equatable {
        var title: String
        var isSelected: Bool
    }

    mutating func resetFilter() {
        self.isOpened = false
        self.suboptions = self.suboptions.map({.init(title: $0.title, isSelected: false)})
    }
}

class FilterViewController: UIViewController {
    let filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()


    var filters: [FilterModel] = []
    weak var delegate: FilterViewControllerDelegate?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupConstraints()
        setupActions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let contentHeight = filterTableView.contentSize.height
//        filterTableView.frame.size.height = contentHeight

    }

    private func setupView() {
        view.backgroundColor = .systemTeal
        view.addSubview(filterTableView)
        setupTableView()
    }

    private func setupNavBar() {
        title = "Filter"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = .separator

        navigationBarAppearance.backgroundColor = UIColor.systemTeal
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetAction(_:)))
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActions() {

    }

    private func setupTableView() {
        filterTableView.register(FilterSectionCell.self, forCellReuseIdentifier: String(describing: FilterSectionCell.self))
        filterTableView.register(FilterSectionRowCell.self, forCellReuseIdentifier: String(describing: FilterSectionRowCell.self))
        filterTableView.delegate = self
        filterTableView.dataSource = self

    }

    @objc func resetAction(_ sender: UIButton) {
        delegate?.resetFilters()
    }

}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].isOpened ? filters[section].suboptions.count + 1 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getSectionCell(tableView, cellForRowAt: indexPath)
        } else {
            return getSectionRowCell(tableView, cellForRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadSections([indexPath.section], with: .automatic)
        delegate?.rowSelected(indexPath: indexPath, filter: filters[indexPath.section])
//        if let cell = tableView.cellForRow(at: indexPath) as? FilterSectionCell {}
    }

    private func getSectionCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FilterSectionCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterSectionCell.self)) as? FilterSectionCell else {
            fatalError("FilterSectionCell not registered")
        }

        cell.configure(text: filters[indexPath.section].title, isOpened: filters[indexPath.section].isOpened)
        cell.selectionStyle = .none
        return cell
    }

    private func getSectionRowCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FilterSectionRowCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterSectionRowCell.self)) as? FilterSectionRowCell else {
            fatalError("FilterSectionRowCell not registered")
        }

        cell.configure(text: filters[indexPath.section].suboptions[indexPath.row - 1].title)
        cell.selectionStyle = .none
        return cell
    }
}
struct FilterView: View {
    var body: some View {
        ViewControllerPreview(viewController: UINavigationController(rootViewController: FilterViewController()))
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}

extension FilterViewController: FilterViewControllerProtocol {
    func updateFilters(_ filters: [FilterModel]) {
        self.filters = filters
    }

    func reloadData() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.filterTableView.reloadData()
        }
/**        UIView.transition(
            with: filterTableView,
            duration: 1.0,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.filterTableView.reloadData()
            },
            completion: nil)
 */
    }

    func reloadSection(at indexPath: IndexPath, filterModel: FilterModel) {
        self.filters[indexPath.section] = filterModel
        self.filterTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}
