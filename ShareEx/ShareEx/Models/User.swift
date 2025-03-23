//
//  User.swift
//  ShareEx
//
//  Created by Jaymeen Unadkat on 23/03/25.
//

import Foundation

struct User: Codable, Hashable {
    var id: UUID = UUID()
    let title: String
    
    var isSelected: Bool = false
}
