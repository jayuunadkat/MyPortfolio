//
//  FilterSectionCell.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 25/03/25.
//

import UIKit
import SwiftUI

class FilterSectionCell: UITableViewCell {

    var isOpened: Bool = false {
        didSet {
            rotateArrowIfNeeded()
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    let arrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let image = UIImage(systemName: "chevron.right") {
            let config = UIImage.SymbolConfiguration(weight: .semibold)
            let boldImage = image.withConfiguration(config)
            button.setImage(boldImage, for: .normal)
        }

        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true

        button.tintColor = .systemTeal
        return button
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -16),

            arrowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    func configure(text: String, isOpened: Bool = false) {
        titleLabel.text = text
        self.isOpened = isOpened
    }

    func toggle(_ isOpened: Bool) {
        self.isOpened = isOpened
    }

    private func rotateArrowIfNeeded() {
        UIView.animate(withDuration: 0.4, animations: {
            if self.isOpened {
                self.arrowButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
            } else {
                self.arrowButton.transform = .identity
            }
        })
    }
}

struct FilterSectionCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TableViewCellPreview<FilterSectionCell> { cell in
                cell.configure(text: "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test")
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
