//
//  APIManager.swift
//  OneRoasterUserData
//
//  Created by Jaymeen Unadkat on 24/02/25.
//


import UIKit
import SystemConfiguration
import SwiftUI
import Alamofire

//MARK: - APIManager
final class APIManager {
    static let shared = APIManager()
    var authToken: String {
        if !(UserDefaults.standard.loginUser?.accessToken ?? "").isEmpty {
            return "Bearer \(UserDefaults.standard.loginUser?.accessToken ?? "")"
        } else {
            return ""
        }
    }
    var headers: HTTPHeaders {
        get {
            return [
                NetworkConstants.ApiHeaders.kContentType   : "application/json",
                NetworkConstants.ApiHeaders.kAuthorization : authToken
            ]
        }
    }
    
    private init() {
        print(UserDefaults.standard.dictionaryRepresentation())
    }
}


//MARK: - GET API Request Call
///`Get API Request`
extension APIManager {
    func getApiRequest<T: Codable>(
        api: APIEndPoints,
        type: T.Type,
        showLoader: Bool = true,
        success: @escaping (_ responseObject: T?, _ message: String) -> Void,
        failure: @escaping (_ error: String,_ isAuth: Bool) -> Void
    ) {
        if showLoader {
            Indicator.show()
        }
        let url = NetworkConstants.shared.environment.serverBaseURL + api.rawValue
        
        guard let urlIs = URL(string: url) else {
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
            return
        }
        if(APIManager.shared.isConnectedToNetwork()) {
            
            AF.request(
                urlIs,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers) {
                    $0.timeoutInterval = 300
                }
                .responseDecodable(of: BaseModel<T>.self) { response in
                
                Indicator.hide()
                guard let str = response.data?.prettyPrintedJSONString else { return }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode ?? 0 == 200 {
                        success(data.data, data.message ?? "")
                        return
                    } else {
                        failure(data.message ?? "", response.response?.statusCode == 401)
                        Logger.log(logType: .error, object: data.message ?? "")
                        return
                    }
                case.failure(let error):
                    failure(AlertMessages.Generic.Error.kCommonErrorMessage, response.response?.statusCode == 401)
                    Logger.log(logType: .error, object: error.localizedDescription)
                    return
                }
            }
        } else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
        }
    }
    
    func getApiRequestWithDynamicURL<T: Codable>(
        url: String,
        type: T.Type,
        showLoader: Bool = true,
        success: @escaping (_ responseObject: T?, _ message: String) -> Void,
        failure: @escaping (_ error: String,_ isAuth: Bool) -> Void
    ) {
        if showLoader {
            Indicator.show()
        }
        
        guard let urlIs = URL(string: url) else {
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
            return
        }
        if(APIManager.shared.isConnectedToNetwork()) {
            
            AF.request(
                urlIs,
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers) {
                    $0.timeoutInterval = 300
                }
                .responseDecodable(of: BaseModel<T>.self) { response in
                
                Indicator.hide()
                guard let str = response.data?.prettyPrintedJSONString else { return }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode ?? 0 == 200 {
                        success(data.data, data.message ?? "")
                        return
                    } else {
                        failure(data.message ?? "", response.response?.statusCode == 401)
                        Logger.log(logType: .error, object: data.message ?? "")
                        return
                    }
                case.failure(let error):
                    failure(AlertMessages.Generic.Error.kCommonErrorMessage, response.response?.statusCode == 401)
                    Logger.log(logType: .error, object: error.localizedDescription)
                    return
                }
            }
        } else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
        }
    }
}

//MARK: - Post API Request Call
///`Post API Request`
extension APIManager {
    func postApiRequest<T: Codable>(
        api: APIEndPoints,
        params: [String:Any],
        objectType:T.Type,
        showLoader: Bool = true,
        success: @escaping (_ responseObject: T?, _ message: String) -> Void,
        failure: @escaping (_ error: String, _ isAuth: Bool) -> Void,
        customFailure: ((_ error: String, _ isAuth: Bool) -> Void)? = nil
    ) {
        if showLoader {
            Indicator.show()
        }
        let url = NetworkConstants.shared.environment.serverBaseURL + api.rawValue
        guard let urlIs = URL(string: url) else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
            return
        }
        Logger.log(logType: .info, object: "Authorization -- \("Bearer \(UserDefaults.standard.loginUser?.accessToken ?? "")")")
        Logger.log(logType: .info, object: params)
        
        if(APIManager.shared.isConnectedToNetwork()) {
            AF.request(
                urlIs,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers) {
                $0.timeoutInterval = 300
            }
            .responseDecodable(of: BaseModel<T>.self) { response in
                
                guard let str = response.data?.prettyPrintedJSONString else {
                    Indicator.hide()
                    return
                }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)
                
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode ?? 0 == 200 {
                        success(data.data, data.message ?? "")
                        return
                    } else {
                        if response.response?.statusCode ?? 0 == 403 {
                            customFailure?(data.message ?? "", false)
                            Logger.log(logType: .error, object: data.message ?? "")
                        } else {
                            failure(data.message ?? "", response.response?.statusCode == 401)
                            Logger.log(logType: .error, object: data.message ?? "")
                        }
                        return
                    }
                    
                case.failure(let error):
                    failure(AlertMessages.Generic.Error.kCommonErrorMessage, response.response?.statusCode == 401)
                    Logger.log(logType: .error, object: error.localizedDescription)
                    return
                }
            }
        } else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kNoInternetConnection,false)
        }
    }
    
    func postApiRequestWithDynamicURL<T: Codable>(
        url: String,
        params: [String:Any],
        objectType:T.Type,
        showLoader: Bool = true,
        success: @escaping (_ responseObject: T?, _ message: String) -> Void,
        failure: @escaping (_ error: String, _ isAuth: Bool) -> Void,
        customFailure: ((_ error: String, _ isAuth: Bool) -> Void)? = nil
    ) {
        if showLoader {
            Indicator.show()
        }
        guard let urlIs = URL(string: url) else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
            return
        }
        Logger.log(logType: .info, object: "Authorization -- \("Bearer \(UserDefaults.standard.loginUser?.accessToken ?? "")")")
        Logger.log(logType: .info, object: params)
        
        if(APIManager.shared.isConnectedToNetwork()) {
            AF.request(
                urlIs,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: headers) {
                $0.timeoutInterval = 300
            }
            .responseDecodable(of: BaseModel<T>.self) { response in
                
                guard let str = response.data?.prettyPrintedJSONString else {
                    Indicator.hide()
                    return
                }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)
                
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode ?? 0 == 200 {
                        success(data.data, data.message ?? "")
                        return
                    } else {
                        if response.response?.statusCode ?? 0 == 403 {
                            customFailure?(data.message ?? "", false)
                            Logger.log(logType: .error, object: data.message ?? "")
                        } else {
                            failure(data.message ?? "", response.response?.statusCode == 401)
                            Logger.log(logType: .error, object: data.message ?? "")
                        }
                        return
                    }
                    
                case.failure(let error):
                    failure(AlertMessages.Generic.Error.kCommonErrorMessage, response.response?.statusCode == 401)
                    Logger.log(logType: .error, object: error.localizedDescription)
                    return
                }
            }
        } else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kNoInternetConnection,false)
        }
    }
}

//MARK: - Post Form Data API Call
///`Post Form API data request`
extension APIManager {
    func postFormDataApiRequest<T: Codable>(
        api: APIEndPoints,
        params: [String: Any],
        objectType: T.Type,
        success: @escaping(_ responseObject: T?,  _ message: String) -> Void,
        failure: @escaping (_ error: String, _ isAuth: Bool) -> Void
    ) {
        Indicator.show()
        if APIManager.shared.isConnectedToNetwork() {
            let url = NetworkConstants.shared.environment.serverBaseURL + api.rawValue
            guard let urlIs = URL(string: url) else {
                Indicator.hide()
                failure(AlertMessages.Generic.Error.kCommonErrorMessage, false)
                return
            }
            Logger.log(logType: .info, object: "Authorization -- \("Bearer \(UserDefaults.standard.loginUser?.accessToken ?? "")")")
//            Logger.log(logType: .info, object: params)
            AF.upload(multipartFormData: { multiPartData in
                for (key, value) in params {
                    if value is UIImage {
                        let img = (value as? UIImage)?.jpegData(compressionQuality: 0.5)
                        multiPartData.append(
                            img ?? Data(),
                            withName: key,
                            fileName: "img.jpeg",
                            mimeType: "image/jpeg"
                        )
                    } else if value is [UIImage] {
                        if let images = value as? [UIImage] {
                            for (index,item) in images.enumerated() {
                                if let imageData = item.jpegData(compressionQuality: 0.5) {
                                    multiPartData.append(
                                        imageData ,
                                        withName: "\(key)[\(index)]",
                                        fileName: "img\(index).jpeg",
                                        mimeType: "image/jpeg"
                                    )
                                }
                            }
                        }
                    }
                    
                    else if value is NSArray {
                        for childValue in value as? NSArray ?? [] {
                            let currentTimeStamp = Date().toMillies()
                            if childValue is UIImage {
                                let img = (childValue as? UIImage)?.jpegData(compressionQuality: 0.5)
                                multiPartData.append(
                                    img!,
                                    withName: key,
                                    fileName: "\(currentTimeStamp!).png",
                                    mimeType: "image/jpeg"
                                )
                            }
                        }
                    }
                    else if value is NSURL || value is URL {
                        do {
                            guard let pdf: URL = value as? URL else { return }
                            let name = pdf.lastPathComponent
                            let mimeType = pdf.mimeType()
                            let pdfData = try Data(contentsOf: pdf)
                            multiPartData.append(
                                pdfData,
                                withName: key,
                                fileName: name,
                                mimeType: mimeType
                            )
                        } catch { print(error) }
                        
                    } else {
                        if value is String || value is Int || value is Bool || value is Double {
                            multiPartData.append(
                                "\(value)".data(using: .utf8)!,
                                withName: key
                            )
                        }
                    }
                }
            }, 
              to: urlIs,
              method: .post,
              headers: headers) {
                $0.timeoutInterval = 300
            }
            .responseDecodable(of: BaseModel<T>.self) { response in
                Indicator.hide()
                guard let str = response.data?.prettyPrintedJSONString else { return }
                Logger.logResponse(ofAPI: url, logType: .info, object: str)

                switch response.result {
                case .success(let data):
                    if response.response?.statusCode ?? 0 == 200 {
                        success(data.data, data.message ?? "")
                        return
                    } else {
                        failure(data.message ?? "", response.response?.statusCode == 401)
                        Logger.log(logType: .error, object: data.message ?? "")
                        return
                    }
                    
                case .failure(let error):
                    failure(error.localizedDescription, response.response?.statusCode == 401)
                    Logger.log(logType: .error, object: error.localizedDescription)
                }
            }
        } else {
            Indicator.hide()
            failure(AlertMessages.Generic.Error.kNoInternetConnection, false)
        }
    }
}

//MARK: - DownloadFile
/// `for downloading a specific file with url`
extension APIManager {
    func downloadFile(
        withURL url: String,
        openPrinter : Bool,
        completion: @escaping ((_ fileURLPath: URL?,_ errorMessage: String?) -> ())
    ) {
        let name = URL(string: url)?.lastPathComponent
        
        let destinationPath: DownloadRequest.Destination = { temporaryURL , response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name ?? "newFile.pdf")
            return(fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(URL(string: url)!, to: destinationPath)
            .downloadProgress { progress in
                Indicator.show()
            }
            .responseData { response in
                switch response.result {
                case .success:
                    completion(response.fileURL, "")
                    Indicator.hide()
                    Alert.show(title: "Success!", message: "File saved successfully.")
                case .failure:
                    completion(nil, response.error?.localizedDescription ?? "")
                    Indicator.hide()
                    break
                }
            }
    }
}
