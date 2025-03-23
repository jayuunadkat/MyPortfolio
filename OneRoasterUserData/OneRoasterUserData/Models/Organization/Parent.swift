// MARK: - Parent
struct Parent: Codable {
    let href: String?
    let sourcedID, type: String?

    enum CodingKeys: String, CodingKey {
        case href
        case sourcedID = "sourcedId"
        case type
    }
}
