//
//  FilterSectionRowCell.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 25/03/25.
//

import UIKit
import SwiftUI

class FilterSectionRowCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.alignment = .center

        return stackView
    }()

    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    private func setupCell() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        contentView.addSubview(mainStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 * 2),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(text: String) {
        titleLabel.text = text
    }
}

struct FilterSectionRowCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TableViewCellPreview<FilterSectionRowCell> { cell in
                cell.configure(text: "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test")
            }
            .previewLayout(.sizeThatFits)
        }
    }
}

