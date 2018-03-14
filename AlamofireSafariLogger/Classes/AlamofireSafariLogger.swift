//
//  SafariLogger.swift
//  SwiftMVVMSample
//
//  Created by Spring Wong on 11/3/2018.
//  Copyright © 2018 Spring Wong. All rights reserved.
//

import Foundation
import Alamofire
import WebKit

public class AlamofireSafariLogger {
    var webview : WKWebView?
    
    // MARK: - Properties
    
    /// The shared network activity logger for the system.
    public static let shared = AlamofireSafariLogger()
    
    /// Omit requests which match the specified predicate, if provided.
    public var filterPredicate: NSPredicate?
    
    public var isGroupCollapse : Bool = true
    public var isLogRequestHeader : Bool = true
    public var isLogRequestBody : Bool = true
    public var isLogResponseHeader : Bool = true
    public var isLogResponseBody : Bool = true
    public var isLogError : Bool = true
    
    public var isDisableLog : Bool = false
    
    // MARK: - Internal - Initialization
    init() {
        webview = WKWebView()
    }
    
    deinit {
        stopLogging()
    }
    
    // MARK: - Logging
    
    /// Start logging requests and responses.
    public func startLogging() {
        stopLogging()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(AlamofireSafariLogger.networkRequestDidStart(notification:)),
            name: Notification.Name.Task.DidResume,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(AlamofireSafariLogger.networkRequestDidComplete(notification:)),
            name: Notification.Name.Task.DidComplete,
            object: nil
        )
    }
    
    /// Stop logging requests and responses.
    public func stopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private - Notifications
    
    @objc private func networkRequestDidStart(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let _ = request.url
            else {
                return
        }
        
        if let filterPredicate = filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }
        if isDisableLog {
            return
        }
        
        let group = (request.urlRequest?.url?.absoluteString)! + " " + httpMethod.description + " Request task:" + String(task.taskIdentifier)
        
        if(isGroupCollapse) {
            logConsoleGroupCollapse(group: group)
        } else {
            logConsoleGroup(group: group)
        }
        logTime(label: String(task.taskIdentifier))
        if isLogRequestHeader {
            logSafariHeader(string: request.allHTTPHeaderFields?.description)
        }
        
        if isLogRequestBody {
            if let httpBody = request.httpBody, let httpBodyString = String(data: httpBody, encoding: .utf8) {
                logSafariBody(string: httpBodyString)
            }
        }
        
        logConsoleGroupEnd()
    }
    
    @objc private func networkRequestDidComplete(notification: Notification) {
        guard let sessionDelegate = notification.object as? SessionDelegate,
            let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let _ = request.url
            else {
                return
        }
        
        if let filterPredicate = filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }
        
        if isDisableLog {
            return
        }
        
        let group = (request.urlRequest?.url?.absoluteString)! + " " + httpMethod.description + " Response task:" + String(task.taskIdentifier)
        if isGroupCollapse {
            logConsoleGroupCollapse(group: group)
        }else {
             logConsoleGroup(group: group)
        }
        logTimeEnd(label: String(task.taskIdentifier))
        
        if let error = task.error {
            if isLogError {
                 logSafariError(string: error.localizedDescription)
            }
        } else {
            guard let response = task.response as? HTTPURLResponse else {
                return
            }
            
            if isLogResponseHeader {
                var headers : [String : String] = [:]
                response.allHeaderFields.forEach({ (key, value) in
                    headers[key as! String] = value as? String
                })
                logSafariHeader(string: headers.description)
            }
            
            if isLogResponseBody {
                if let data = sessionDelegate[task]?.delegate.data {
                    if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        logSafariBody(string: string as String)
                    }
                }
            }
        }
        logConsoleGroupEnd()
    }
}
private extension AlamofireSafariLogger {
    func logSafariHeader(string : String?) {
        if let string = string {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.log('" + string + "')", completionHandler: nil)
            }
        }
    }
    
    func logSafariBody (string : String?) {
        if let string = string?.replacingOccurrences(of: "\n", with: "") {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.warn('" + string.replacingOccurrences(of: "'", with: "\\'") + "')", completionHandler: nil)
            }
        }
        
    }
    
    func logSafariError (string : String?) {
        if let string = string?.replacingOccurrences(of: "\n", with: "") {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.error('" + string + "')", completionHandler: nil)
            }
        }
        
    }
    func logConsoleGroup(group : String) {
        DispatchQueue.main.async() {
            self.webview?.evaluateJavaScript("console.group('" + group + "')", completionHandler: nil)
        }
    }
    func logConsoleGroupCollapse(group : String) {
        DispatchQueue.main.async() {
            self.webview?.evaluateJavaScript("console.groupCollapsed('" + group + "')", completionHandler: nil)
        }
    }
    func logConsoleGroupEnd() {
        DispatchQueue.main.async() {
            self.webview?.evaluateJavaScript("console.groupEnd(" + ")", completionHandler: nil)
        }
    }
    func logTime(label:String) {
        DispatchQueue.main.async() {
            self.webview?.evaluateJavaScript("console.time('" + label + "')", completionHandler: nil)
        }
    }
    func logTimeEnd(label:String) {
        DispatchQueue.main.async() {
            self.webview?.evaluateJavaScript("console.timeEnd('" + label + "')", completionHandler: nil)
        }
    }
}



