//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/17/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation
extension UdacityClient
{
    func makeLoginNetworkRequest(username: String, password: String, completionHandler: @escaping (_ success: Bool,_ accountID: String?, _ sessionID: String?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL = buildURL(host: Constants.ApiHostUdacityAccount, apiPath: Constants.ApiPathUdacityAccount, parameters: nil)
        
        // Build request
        let headers: [String: String] = [Constants.HeaderAcceptKey: Constants.HeaderAcceptValue, Constants.ContentTypeKey: Constants.ContentTypeValue]
        let jsonBody = "{ \"udacity\":  { \"username\": \"\(username)\", \"password\": \"\(password)\" } }"
        let request = configureRequest(url: URL, methodType: "POST", headers: headers, jsonBody: jsonBody)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: true)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                completionHandler(false, nil, nil, "Invalid username or password")
                return
            }
            
            var accountDictionary = results![JSONResponseKeys.LoginAccountKey] as? [String: AnyObject]
            var sessionDictionary = results![JSONResponseKeys.LoginSessionKey] as? [String: String]
            
            if(accountDictionary  != nil && sessionDictionary != nil)
            {
                let success = true
                let accountID: String? = accountDictionary![JSONResponseKeys.LoginAccountIdKey] as? String
                let sessionID: String? = sessionDictionary![JSONResponseKeys.LoginSessionIDKey]
                let errorString: String? = nil
                
                completionHandler(success, accountID, sessionID, errorString)
            }
        }
    }
    
    func makeLogoutNetworkRequest(completionHandler: @escaping (_ success: Bool,_ sessionID: String?, _ expiration: String?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL = buildURL(host: Constants.ApiHostUdacityAccount, apiPath: Constants.ApiPathUdacityAccount, parameters: nil)
        
        // Build request
        var headers: [String: String] = [:]
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!
        {
            if cookie.name == "XSRF-TOKEN"
            {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie
        {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        // Configure request
        let request = configureRequest(url: URL, methodType: "DELETE", headers: headers, jsonBody: nil)
        
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: true)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                completionHandler(false, nil, nil, "Invalid username or password")
                return
            }
            
            var sessionDictionary = results![JSONResponseKeys.LoginSessionKey] as? [String: String]
            
            if(sessionDictionary != nil)
            {
                let success = true
                let sessionID: String? = sessionDictionary![JSONResponseKeys.LoginSessionIDKey]
                let expiration: String? = sessionDictionary![JSONResponseKeys.LoginSessionExpirationKey]
                let errorString: String? = nil
                
                completionHandler(success, sessionID, expiration, errorString)
            }
        }
    }
    
    func getStudentLocationNetworkRequest(completionHandler: @escaping (_ success: Bool,_ studentInfoArray:[StudentInformation],_ errorString: String?)->Void)
    {
        // Build URL
        let URL = buildURL(host: Constants.ApiHostStudentLocation, apiPath: Constants.ApiPathStudentLocation, parameters: nil)
        
        // Build request
        let headers: [String: String] = [Constants.XParseApplicationIDKey: Constants.XParseApplicationIDValue,
                                         Constants.XParseRESTAPIKey: Constants.XParseRESTAPIValue]
        let request = configureRequest(url: URL, methodType: "GET", headers: headers, jsonBody: nil)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: false)
        {
            (results: AnyObject?, error: Error?)->Void in
            print(results!)
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                return
            }
            
            let studentInfo = results?["results"] as! [[String: AnyObject]]
            
            var studentInfoArray = [StudentInformation]()
            for item in studentInfo
            {
                let s = StudentInformation (student: item)
                
                if s.isValid()
                {
                    studentInfoArray.append(s)
                }
            }
            let success = true
            let errorString: String? = nil
            completionHandler(success, studentInfoArray, errorString)
            
            print(studentInfoArray)
        }
    }
}
