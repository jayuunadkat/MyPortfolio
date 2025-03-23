//
//  File.swift
//
//
//  Created by Jaymeen on 24/06/23.
//

import Foundation

//MARK: - UserDefault Keys

/// `UserDefaultsKey`
struct UserDefaultsKey {
    static let kAuthToken                           = "Token"
    static let kLoginUser                           = "loginUser"
    static let kLoginUserArr                        = "loginUserArr"
    static let kIsAlreadyLogin                      = "AlreadyLogin"
    static let kIsLogout                            = "Logout"
    static let kDeviceToken                         = "device_token"
    static let kRememberMe                          = "rememberMe"
    static let kSavedEmail                          = "savedEmail"
    static let kshortenDynamicURL                   = "shortenDynamicURL"
    static let kSplashShowed                        = "splashShowed"
    static let kIsLogin                             = "isLogin"
}


//MARK: - UserDefault Extensions

/// `To Set and Get Data to UserDefaults`
extension UserDefaults {
    func setData<T: Codable>(_ data: T, _ key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    /// `To get Data from UserDefault`
    func getData<T: Codable>(_ key: String, data: T.Type) -> T? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            let loadedPerson = try? decoder.decode(data, from: savedPerson)
            return loadedPerson
        } else {
            print("Error")
            return nil
        }
    }
    
    ///`Remove All Data from UserDefaults`
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}


public extension UserDefaults {
    ///`Auth Login`
    class var authLogin : Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kIsLogin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIsLogin)
        }
    }
    
    class var deviceToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kDeviceToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kDeviceToken)
        }
    }
    
    class var isRememberMe: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kRememberMe)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kRememberMe)
        }
    }
    
    class var savedEmail: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kSavedEmail)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kSavedEmail)
        }
    }
}


///`LoginUser`
extension UserDefaults {
   public var loginUser: UserModel? {
        get {
            if object(forKey: #function) != nil {
                if let data = self.value(forKey: #function) as? Data {
                    let myObject = try? PropertyListDecoder().decode(UserModel.self, from: data)
                    return myObject!
                }
            }
            
            return nil
        }
        set {
            set(try? PropertyListEncoder().encode(newValue), forKey: #function)
            synchronize()
        }
    }
    
   public var userCredentials: UserCredentials? {
        get {
            if object(forKey: #function) != nil {
                if let data = self.value(forKey: #function) as? Data {
                    let myObject = try? PropertyListDecoder().decode(UserCredentials.self, from: data)
                    return myObject!
                }
            }
            return nil
        }
        set {
            set(try? PropertyListEncoder().encode(newValue), forKey: #function)
            synchronize()
        }
    }
    
    var currentLocation: SelectedLocation? {
        get {
            if object(forKey: #function) != nil {
                if let data = self.value(forKey: #function) as? Data {
                    let myObject = try? PropertyListDecoder().decode(SelectedLocation.self, from: data)
                    return myObject!
                }
            }
            
            return nil
        }
        set {
            set(try? PropertyListEncoder().encode(newValue), forKey: #function)
            synchronize()
        }
    }
    
    public var selectedRegionalCenter: RegionalCenterCodeModel? {
        get {
            if object(forKey: #function) != nil {
                if let data = self.value(forKey: #function) as? Data {
                    let myObject = try? PropertyListDecoder().decode(RegionalCenterCodeModel.self, from: data)
                    return myObject!
                }
            }
            
            return nil
        }
        set {
            set(try? PropertyListEncoder().encode(newValue), forKey: #function)
            synchronize()
        }
    }
}


///`SelectedLocation`
public struct SelectedLocation: Codable {
    public var lat: Double
    public var long: Double
    
    enum CodingKeys: CodingKey {
        case lat
        case long
    }
}

public struct UserCredentials: Codable {
    public let userEmail: String
    public let userPassword: String
    
    public init(userEmail: String, userPassword: String) {
        self.userEmail = userEmail
        self.userPassword = userPassword
    }
}
