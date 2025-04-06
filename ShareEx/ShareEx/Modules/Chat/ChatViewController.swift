//
//  ChatViewController.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 25/03/25.
//

import UIKit
import SwiftUI

class ChatViewController: UIViewController {
    private let sheetToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.setTitle("Toggle Sheet", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    lazy var filterViewController: FilterViewController? = FilterViewController()
    var filters: [FilterModel] = [
        FilterModel(
            title: "Year",
            isOpened: false,
            suboptions: [
                .init(title: "2025", isSelected: false),
                .init(title: "2024", isSelected: false),
                .init(title: "2023", isSelected: false),
                .init(title: "2022", isSelected: false),
            ]
        ),
        FilterModel(
            title: "Academic Sessions",
            isOpened: false,
            suboptions: [
                .init(title: "Grading Period", isSelected: false),
                .init(title: "School Year", isSelected: false),
                .init(title: "Semester", isSelected: false),
                .init(title: "Term", isSelected: false),
            ]
        ),
    ]
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupConstraints()
        setupActions()
    }

    private func setupView() {
        view.backgroundColor = .systemTeal
        view.addSubview(sheetToggleButton)
    }

    private func setupNavBar() {
        title = "Chat"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = .separator

        navigationBarAppearance.backgroundColor = UIColor.systemTeal
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sheetToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetToggleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupActions() {
        sheetToggleButton.addTarget(self, action: #selector(toggleSheet(_:)), for: .touchUpInside)
    }
}

struct ChatView: View {
    var body: some View {
        ViewControllerPreview(viewController: UINavigationController(rootViewController: ChatViewController()))
    }
}

#Preview {
    ChatView()
}

extension ChatViewController {
    @objc private func toggleSheet(_ sender: UIButton) {
        if let filterViewController = filterViewController {
            filterViewController.delegate = self
            filterViewController.modalPresentationStyle = .formSheet
            present(UINavigationController(rootViewController: filterViewController), animated: true, completion: { [weak self] in
                guard let self else { return }
                self.updateFilters()
            })
        }
    }

    func updateFilters() {
        filterViewController?.updateFilters(filters)
        filterViewController?.reloadData()
    }
}

extension ChatViewController: FilterViewControllerDelegate {
    func rowSelected(indexPath: IndexPath, filter: FilterModel) {
        switch indexPath.row {
        case 0:
            filters[indexPath.section].isOpened.toggle()
            break
        default:
            filters[indexPath.section].isOpened.toggle()
            filters[indexPath.section].suboptions[indexPath.row - 1].isSelected.toggle()
            break
        }

        filterViewController?.reloadSection(at: indexPath, filterModel: filters[indexPath.section])
    }

    func resetFilters() {
        
    }
}
