//
//  OnerosterListCell.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 27/03/25.
//

import UIKit
import SwiftUI

class OnerosterListCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    let currentValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    let oldValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, currentValueLabel, oldValueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textStackView])
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
            currentValueLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8),
            oldValueLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    func configure(
        title: String,
        currentValue: String,
        oldValue: String,
        color: UIColor = .clear
    ) {
        titleLabel.text = title
        currentValueLabel.text = currentValue
        currentValueLabel.isHidden = currentValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        oldValueLabel.text = oldValue
        oldValueLabel.isHidden = oldValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    Group {
        TableViewCellPreview<OnerosterListCell> { cell in
            cell.configure(title: "Test", currentValue: "457", oldValue: "456")
        }
    }
}
