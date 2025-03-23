///`NetworkConstants`
public class NetworkConstants {
    private init() {}
    public static var shared: NetworkConstants = .init()
    
    #if DEBUG
    public var environment: APIEnvironments = .Production
    #else
    public var environment: APIEnvironments = .Production
    #endif
}

public extension NetworkConstants {
    enum APIEnvironments: String, CaseIterable, Equatable {
        case Production
        case Dev1 // Mihir
        case Dev2 // Niranjan
        case Dev3 // Jaymeen
        
        public var serverBaseURL: String {
            switch self {
            case .Production:
//                return "http://dev.uventiapp.com/api/"
                return getURLForProduction()
            case .Dev1:
                return "http://192.168.1.92:8080/api/"
            case .Dev2:
                return "http://192.168.1.139:8080/api/"
            case .Dev3:
                return "http://192.168.1.210:8080/api/"
            }
        }
        
        func getURLForProduction() -> String {
            let selectedEnvironMent: String = UserDefaults.standard.selectedRegionalCenter?.regionalCenterCodeName ?? ""
            var environment: String = "dev"
            
            if selectedEnvironMent.isEmpty == false {
                environment = selectedEnvironMent
            }
            
            return "https://\(environment.lowercased()).uventiapp.com/api/"
        }
        
        static func getURLWithEnvironment(environment: String) -> String {
            return "https://\(environment.lowercased()).uventiapp.com/api/"
        }
    }
}

extension NetworkConstants {
    ///`ApiKeys`
    struct ApiHeaders {
        static let kAuthToken                   = "AuthToken"
        static let kAuthorization               = "Authorization"
        static let kContentType                 = "Content-Type"
    }
    
    public var privacyPolicyURL: String {
        return self.environment.serverBaseURL.replacingOccurrences(of: "/api", with: "") + "privacyPolicy"
    }

    public var termsAndConditions: String {
        return self.environment.serverBaseURL.replacingOccurrences(of: "/api", with: "") + "termsAndConditions"
    }
}
