// MARK: - Application
struct ApplicationModel: Codable, Hashable {
    let id, applicationID, tenantID: Int
    let bearer, tenantName, enabled, oneRosterApplicationID: String
    let name, version: String

    enum CodingKeys: String, CodingKey {
        case id
        case applicationID = "application_id"
        case tenantID = "tenant_id"
        case bearer
        case tenantName = "tenant_name"
        case enabled
        case oneRosterApplicationID = "oneroster_application_id"
        case name, version
    }
}
