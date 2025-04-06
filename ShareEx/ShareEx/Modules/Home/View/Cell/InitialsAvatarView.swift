//
//  InitialsAvatarView.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import UIKit

class InitialsAvatarView: UIView {

    private let initialsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .gray
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 40),
            heightAnchor.constraint(equalToConstant: 40),
            initialsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            initialsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            initialsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        ])
    }

    func setupInitials(from name: String, color: UIColor = .red) {
        let firstLetter = name.trimmingCharacters(in: .whitespacesAndNewlines).first?.uppercased() ?? "?"
        initialsLabel.text = firstLetter
        backgroundColor = getBackgroundColor(for: firstLetter.first!)

        if color != .clear {
            addBorder(with: color)
            addShadow(with: color)
        }
    }

    private func addBorder(with color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
    }

    private func addShadow(with color: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
    }
}

extension InitialsAvatarView {
    private func getBackgroundColor(for initial: Character) -> UIColor {
        switch initial.uppercased() {
        case "A": return UIColor(hex: "#264653") /// dark teal
        case "B": return UIColor(hex: "#2a9d8f") /// muted green
        case "C": return UIColor(hex: "#e76f51") /// burnt orange
        case "D": return UIColor(hex: "#e63946") /// soft red
        case "E": return UIColor(hex: "#6a994e") /// olive green
        case "F": return UIColor(hex: "#1d3557") /// navy blue
        case "G": return UIColor(hex: "#457b9d") /// steel blue
        case "H": return UIColor(hex: "#4a4e69") /// muted purple
        case "I": return UIColor(hex: "#8338ec") /// vibrant purple
        case "J": return UIColor(hex: "#3a0ca3") /// dark violet
        case "K": return UIColor(hex: "#ff6b6b") /// coral red
        case "L": return UIColor(hex: "#f4a261") /// soft orange
        case "M": return UIColor(hex: "#bc6c25") /// copper
        case "N": return UIColor(hex: "#7209b7") /// deep purple
        case "O": return UIColor(hex: "#2b9348") /// forest green
        case "P": return UIColor(hex: "#3f88c5") /// rich blue
        case "Q": return UIColor(hex: "#ff006e") /// hot pink
        case "R": return UIColor(hex: "#1982c4") /// blue sky
        case "S": return UIColor(hex: "#6a4c93") /// eggplant
        case "T": return UIColor(hex: "#0081a7") /// teal
        case "U": return UIColor(hex: "#00afb9") /// aqua
        case "V": return UIColor(hex: "#a8dadc") /// pale blue
        case "W": return UIColor(hex: "#ffb703") /// mustard
        case "X": return UIColor(hex: "#fb8500") /// orange
        case "Y": return UIColor(hex: "#d62828") /// crimson
        case "Z": return UIColor(hex: "#8ecae6") /// icy blue
        default:  return UIColor.darkGray
        }
    }
}
