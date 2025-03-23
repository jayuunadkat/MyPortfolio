//
//  File.swift
//  
//
//  Created by differenz210 on 22/05/24.
//

import Foundation
import SwiftUI
import UIKit

///`AlertData`

public class AlertData {
    
    public static let empty = AlertData(title: "Sample", message: "Empty", isLogOut: false)
    public var title: String
    public var message: String
    public var isLogOut: Bool
    
    
    private(set) public var dismissButton: Alert.Button = .default(Text("OK"))
    
    public init(title: String, message: String, isLogOut: Bool) {
        
        self.title = title
        self.message = message
        self.isLogOut = isLogOut
        
        if isLogOut {
            dismissButton = .default(Text("OK")){
//                NavigationUtil.popToRootView()
//                UserDefaults.authLogin = false
                
            }
        }
    }
}

//MARK: -  Extension Alert
public extension Alert {
    //Authentication expired and Common message  Alert
    static func show(title: String = "", message: String = "", isLogOut: Bool = false) {
        NotificationCenter.default.post(name: .showAlert, object: AlertData(title: title, message: message, isLogOut: isLogOut))
        
    }
}


#if os(iOS)
public class UIUtilities: NSObject {
    /// `change alert tint color`
    public class func changeAlertTintColor(tintColor: UIColor) {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = tintColor
//        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).backgroundColor = .darkGray
    }
    
    public class func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
