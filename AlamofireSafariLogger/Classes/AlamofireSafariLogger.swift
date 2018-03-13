//
//  SafariLogger.swift
//  SwiftMVVMSample
//
//  Created by Spring Wong on 11/3/2018.
//  Copyright © 2018 Spring Wong. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

public class AlamofireSafariLogger {
    var webview : WKWebView?
    
    // MARK: - Properties
    
    /// The shared network activity logger for the system.
    public static let shared = AlamofireSafariLogger()
    
    /// Omit requests which match the specified predicate, if provided.
    public var filterPredicate: NSPredicate?
    
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
            let requestURL = request.url
            else {
                return
        }
        
        if let filterPredicate = filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }
        
        logTime(string: (request.urlRequest?.url?.absoluteString)! + " " + httpMethod.description)
        logSafariHeader(string: request.allHTTPHeaderFields?.description)
        
        if let httpBody = request.httpBody, let httpBodyString = String(data: httpBody, encoding: .utf8) {
            logSafariLog(requestURL.absoluteString, string: httpBodyString, title : "Request Body")
        }
    }
    
    @objc private func networkRequestDidComplete(notification: Notification) {
        guard let sessionDelegate = notification.object as? SessionDelegate,
            let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let requestURL = request.url
            else {
                return
        }
        
        if let filterPredicate = filterPredicate, filterPredicate.evaluate(with: request) {
            return
        }
        logTime(string: (request.urlRequest?.url?.absoluteString)! + " " + httpMethod.description + " Response!!!")
        
        if let error = task.error {
            logSafariError(requestURL.absoluteString, string: error.localizedDescription, title: "Response Error")
        } else {
            guard let response = task.response as? HTTPURLResponse else {
                return
            }
            
            var headers : [String : String] = [:]
            response.allHeaderFields.forEach({ (key, value) in
                headers[key as! String] = value as? String
            })
            logSafariHeader(string: headers.description)
            
            if let data = sessionDelegate[task]?.delegate.data {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    logSafariLog(requestURL.absoluteString, string: string as String, title: "Response")
                }
            }
        }
    }
}
private extension AlamofireSafariLogger {
    func logTime(string : String?) {
        if let string = string {
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd.MM.yyyy hh:mm:ss.SSS"
            let time = formatter.string(from: date)
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.log('" + time + " : " + string + "')", completionHandler: nil)
            }
        }
    }
    func logSafariHeader(string : String?) {
        if let string = string {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.log('" + string + "')", completionHandler: nil)
            }
        }
    }
    
    func logSafariLog (_ url : String , string : String?, title : String = "") {
        if let string = string?.replacingOccurrences(of: "\n", with: "") {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.warn('" + string.replacingOccurrences(of: "'", with: "\\'") + "')", completionHandler: nil)
            }
        }
        
    }
    
    func logSafariError (_ url : String , string : String?, title : String = "") {
        if let string = string?.replacingOccurrences(of: "\n", with: "") {
            DispatchQueue.main.async() {
                self.webview?.evaluateJavaScript("console.error('" + string + "')", completionHandler: nil)
            }
        }
        
    }
}



