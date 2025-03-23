//
// File.swift
// 
// Created by Jaymeen Unadkat on 24/06/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation

class Logger {
    enum LogType: String{
        case error = " 🔴 💀 Error"
        case warning = "🔥 Warning"
        case success = "🎉 Success"
        case failure = "🔴 Failure"
        case action = "🎬 Action"
        case canceled = "📓 Cancelled"
        case value = "📐 Value"
        case info = "⚠️ Info"
    }
    
    static func logResponse(ofAPI api: String, logType: LogType, object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        let className = (fileName as NSString).lastPathComponent
        
#if DEBUG
        print("------------------⬇️")
        print("\(logType.rawValue)")
        print("📂 <\(className)>")
        print("➡️ \(functionName)")
        print("#️⃣ [\(lineNumber)]")
        print("🖥️ \(api)")
        print("\(object)")
        print("------------------⬆️")
#endif
    }
    
    static func log(logType: LogType, object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        let className = (fileName as NSString).lastPathComponent

#if DEBUG
        print("\(logType.rawValue)")
        print("📂 <\(className)>")
        print("➡️ \(functionName)")
        print("#️⃣ [\(lineNumber)]")
        if let object = object as? [String: Any], let prettyDictData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted), let prettyDict = String(data: prettyDictData, encoding: .utf8) {
            print("\(prettyDict)")
        } else {
            print("\(object)")
        }
#endif
    }
}
