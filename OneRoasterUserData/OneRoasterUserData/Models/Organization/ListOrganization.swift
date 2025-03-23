//
//  Org.swift
//  OneRoasterUserData
//
//  Created by Jaymeen Unadkat on 24/02/25.
//


// MARK: - Org
struct Org: Codable {
    let sourcedID, status, dateLastModified, name: String
    let type, identifier: String
    let parent: Parent
    let children: [Parent]

    enum CodingKeys: String, CodingKey {
        case sourcedID = "sourcedId"
        case status, dateLastModified, name, type, identifier, parent, children
    }
}

// MARK: - Parent
struct Parent: Codable {
    let href: String
    let sourcedID, type: String

    enum CodingKeys: String, CodingKey {
        case href
        case sourcedID = "sourcedId"
        case type
    }
}
