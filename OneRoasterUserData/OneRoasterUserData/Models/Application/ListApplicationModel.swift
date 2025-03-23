// MARK: - ListApplicationModel
struct ListApplicationModel: Codable {
    let status: Int
    let applications: [Application]
}

// MARK: - Application
struct Application: Codable {
    let id, applicationID, tenantID: Int
    let bearer, tenantName, enabled, onerosterApplicationID: String
    let name, version: String

    enum CodingKeys: String, CodingKey {
        case id
        case applicationID = "application_id"
        case tenantID = "tenant_id"
        case bearer
        case tenantName = "tenant_name"
        case enabled
        case onerosterApplicationID = "oneroster_application_id"
        case name, version
    }
}
