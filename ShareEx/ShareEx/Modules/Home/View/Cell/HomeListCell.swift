//
//  HomeListCell.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit
import SwiftUI

class HomeListCell: UITableViewCell {

    let avatarView: InitialsAvatarView = InitialsAvatarView()

    let checkboxView: CheckboxView = {
        let checkBox = CheckboxView()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        return checkBox
    }()

    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, textStackView, checkboxView])
        stack.axis = .horizontal

        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
//            checkboxView.widthAnchor.constraint(equalToConstant: 28),
//            checkboxView.heightAnchor.constraint(equalToConstant: 28),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    func configure(title: String, subtitle: String, showCheckBox: Bool = false) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle.isEmpty
        avatarView.setupInitials(from: title)

        if showCheckBox {
            checkboxView.isHidden = false
            checkboxView.delegate = self
        } else {
            checkboxView.isHidden = true
        }
    }

    func toggleCheckBox() {
        if !checkboxView.isHidden {
            checkboxView.toggle()
        }
    }
}

extension HomeListCell: CheckboxViewDelegate {
    func checkboxView(_ checkboxView: CheckboxView, didChangeState isChecked: Bool) {
        print("Checkbox state changed to: \(isChecked)")
    }
}

struct BaseTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TableViewCellPreview<HomeListCell> { cell in
                cell.configure(title: "Example Title", subtitle: "This is a more generic subtitle that can span multiple lines and should wrap appropriately.")
            }
            .previewLayout(.sizeThatFits)
            .padding()
//            .preferredColorScheme(.dark)
//            .previewDisplayName("Light Mode")
        }
    }
}
