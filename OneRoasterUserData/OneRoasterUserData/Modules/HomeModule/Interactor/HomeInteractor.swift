//
//  HomeInteractor.swift
//  OneRoasterUserData
//
//  Created by Jaymeen Unadkat on 24/02/25.
//

import Foundation

protocol HomeInteractorProtocol {
    func fetchCurrentOrganisation() async throws -> ApplicationModel?
    func listDistricts() async throws -> ListOrganization
}

class HomeInteractor: HomeInteractorProtocol {
    var homeDataManager: HomeDataManagerProtocol

    init(manager: HomeDataManagerProtocol = HomeDataManager()) {
        self.homeDataManager = manager
    }

    func fetchCurrentOrganisation() async throws -> ApplicationModel? {
        do {
            let applications: [ApplicationModel] = try await homeDataManager.fetchApplications()
            let currentOrg = applications.first(where: {$0.name == Constants.applicationRosterNameKey})

            if let currentOrg = currentOrg {
                UserDefaults.standard.currentOrganisation = currentOrg
                UserDefaults.accessToken = currentOrg.bearer
            }

            return currentOrg
        } catch {
            throw error
        }
    }


    func listDistricts() async throws -> ListOrganization {
        let organizations = try await homeDataManager.listOrganizations()

        let districts = organizations.filter { $0.type == .DISTRICT }

        return districts
    }
}


/**

 func listOrganizations() async throws -> ListOrganization {
 let organizations = try await homeDataManager.listOrganizations()

 let districts = organizations.filter { $0.type == .DISTRICT }
 let schools = organizations.filter { $0.type == .SCHOOL }

 let districtWithSchools = bindDistrictsWithSchools(districts: districts, schools: schools)

 return districtWithSchools
 }

 private func bindDistrictsWithSchools(districts: ListOrganization, schools: ListOrganization) -> ListOrganization {

 var tempSchools: [String: ListOrganization] = [:]
 var tempDistricts: ListOrganization = districts

 for school in schools {
 tempSchools[school.parent.sourcedID ?? "", default: []].append(school)
 }

 for i in 0..<tempDistricts.count {
 if let schoolsForDistrict = tempSchools[tempDistricts[i].sourcedID] {
 tempDistricts[i].childrenSchools = Array(schoolsForDistrict)
 }
 }

 return tempDistricts
 }

 */
