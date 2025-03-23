//
//  TableViewCellPreview.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//


import SwiftUI
import UIKit

struct TableViewCellPreview<Cell: UITableViewCell>: UIViewRepresentable {
    let configure: (Cell) -> Void

    func makeUIView(context: Context) -> UIView {
        let cell = Cell(style: .default, reuseIdentifier: nil)
        configure(cell)
        return cell.contentView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
