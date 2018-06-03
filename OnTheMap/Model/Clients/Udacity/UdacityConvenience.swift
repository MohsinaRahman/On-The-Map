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
        let URL = buildURL(host: Constants.ApiHostUdacityAccount, apiPath: Constants.ApiPathUdacitySession, parameters: nil)
        
        // Build request
        let headers: [String: String] = [Constants.HeaderAcceptKey: Constants.HeaderAcceptValue, Constants.ContentTypeKey: Constants.ContentTypeValue]
        let jsonBody = "{ \"udacity\":  { \"username\": \"\(username)\", \"password\": \"\(password)\" } }"
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodPOST, headers: headers, jsonBody: jsonBody)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: true)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil, nil, "No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, nil, "Invalid email or password")
                }
                
                return
            }
            
            var accountDictionary = results![Constants.JSONResponseKeys.LoginAccountKey] as? [String: AnyObject]
            var sessionDictionary = results![Constants.JSONResponseKeys.LoginSessionKey] as? [String: String]
            
            if(accountDictionary  != nil && sessionDictionary != nil)
            {
                let success = true
                let accountID: String? = accountDictionary![Constants.JSONResponseKeys.LoginAccountIdKey] as? String
                let sessionID: String? = sessionDictionary![Constants.JSONResponseKeys.LoginSessionIDKey]
                let errorString: String? = nil
                
                completionHandler(success, accountID, sessionID, errorString)
            }
        }
    }
    
    
    func makeLogoutNetworkRequest(completionHandler: @escaping (_ success: Bool,_ sessionID: String?, _ expiration: String?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL = buildURL(host: Constants.ApiHostUdacityAccount, apiPath: Constants.ApiPathUdacitySession, parameters: nil)
        
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
            headers[Constants.HeaderXXSRFTokenKey] = xsrfCookie.value
        }
        
        // Configure request
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodDELETE, headers: headers, jsonBody: nil)
        
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: true)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil, nil, "No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, nil, "Invalid email or password")
                }
                
                return
            }
            
            var sessionDictionary = results![Constants.JSONResponseKeys.LoginSessionKey] as? [String: String]
            
            if(sessionDictionary != nil)
            {
                let success = true
                let sessionID: String? = sessionDictionary![Constants.JSONResponseKeys.LoginSessionIDKey]
                let expiration: String? = sessionDictionary![Constants.JSONResponseKeys.LoginSessionExpirationKey]
                let errorString: String? = nil
                
                completionHandler(success, sessionID, expiration, errorString)
            }
        }
    }
    
    func getStudentLocationNetworkRequest(uniqueKey: String?, completionHandler: @escaping (_ success: Bool,_ studentInfoArray:[StudentInformation],_ errorString: String?)->Void)
    {
        // Build URL
        let URL : URL
        var parameters : [String: AnyObject] = [:]
        var key: String
        var value: String
        
        // Add the unique key
        if(uniqueKey != nil)
        {
            // Add the unique ID
            key = "where"
            value = "{\"\(Constants.JSONResponseKeys.StudentUniqueKey)\":\"\(uniqueKey!)\"}"
            parameters[key] = value as AnyObject
        }
        
        // Add the order (use - for descending)
        key = "order"
        value = "-\(Constants.JSONResponseKeys.StudentUpdatedAt)"
        parameters[key] = value as AnyObject
        
        URL = buildURL(host: Constants.ApiHostStudentLocation, apiPath: Constants.ApiPathStudentLocation, parameters: parameters)
        
        // Build request
        let headers: [String: String] = [Constants.XParseApplicationIDKey: Constants.XParseApplicationIDValue,
                                         Constants.XParseRESTAPIKey: Constants.XParseRESTAPIValue]
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodGET, headers: headers, jsonBody: nil)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: false)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, [], "No Internet Connection")
                }
                else
                {
                    completionHandler(false, [], "Error downloading student location information")
                }
                
                return
            }
            
            print(results!)
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
    
    func getPublicUserDataNetworkRequest(uniqueKey: String, completionHandler: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?,_ errorString: String?)->Void)
    {
        // Build URL
        let apiPath = substituteKeyInMethod(Constants.ApiPathUdacityUserData, key: "id", value: uniqueKey)
        let URL = buildURL(host: Constants.ApiHostUdacityAccount, apiPath: apiPath!, parameters: nil)
        
        // Build request
        let headers: [String: String] = [Constants.XParseApplicationIDKey: Constants.XParseApplicationIDValue,
                                         Constants.XParseRESTAPIKey: Constants.XParseRESTAPIValue]
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodGET, headers: headers, jsonBody: nil)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: true)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil, nil, "No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, nil, "Invalid user ID")
                }
                
                return
            }
            
            var userDictionary = results!["user"] as? [String: AnyObject]
            
            if(userDictionary != nil)
            {
                let success = true
                let firstName: String? = userDictionary!["first_name"] as? String
                let lastName: String? = userDictionary!["last_name"] as? String
                let errorString: String? = nil
                
                completionHandler(success, firstName, lastName, errorString)
            }
        }
    }
    
    func postStudentLocation(s: StudentInformation,  completionHandler: @escaping (_ success: Bool, _ createdAt: String?, _ objectID: String?, _ errorString: String?)->Void)
    {
        // Build URL
        let URL = buildURL(host: Constants.ApiHostStudentLocation, apiPath: Constants.ApiPathStudentLocation, parameters: nil)
        
        // Build request
        let headers: [String: String] = [
            Constants.XParseApplicationIDKey: Constants.XParseApplicationIDValue,
            Constants.XParseRESTAPIKey: Constants.XParseRESTAPIValue,
            Constants.ContentTypeKey: Constants.ContentTypeValue
        ]
        let jsonBody = "{" +
            "\"\(Constants.JSONResponseKeys.StudentUniqueKey)\": \"\(s.uniqueKey!)\""   + "," +
            " \"\(Constants.JSONResponseKeys.StudentFirstName)\": \"\(s.firstName!)\""  + "," +
            " \"\(Constants.JSONResponseKeys.StudentLastName)\": \"\(s.lastName!)\""    + "," +
            " \"\(Constants.JSONResponseKeys.StudentMapString)\": \"\(s.mapString!)\""  + "," +
            " \"\(Constants.JSONResponseKeys.StudentMediaURL)\": \"\(s.mediaURL!)\""    + "," +
            " \"\(Constants.JSONResponseKeys.StudentLatitude)\": \(s.latitude!)"        + "," +
            " \"\(Constants.JSONResponseKeys.StudentLongitude)\": \(s.longitude!)"      +
        "}"
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodPOST, headers: headers, jsonBody: jsonBody)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: false)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil, nil, "No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, nil, "Unknown error while doing postStudentLocation")
                }
                
                return
            }
            
            print(results!)
            let createdAt = results?[Constants.JSONResponseKeys.StudentCreatedAt] as! String
            let objectID = results?[Constants.JSONResponseKeys.StudentObjectId] as! String
            let success = true
            let errorString: String? = nil
            completionHandler(success, createdAt, objectID, errorString)
        }
    }
    
    func putStudentLocation(s: StudentInformation,  completionHandler: @escaping (_ success: Bool, _ updatedAt: String?, _ errorString: String?)->Void)
    {
        // Build URL
        let apiPath = "\(Constants.ApiPathStudentLocation)/\(s.objectId!)"
        print(apiPath)
        let URL = buildURL(host: Constants.ApiHostStudentLocation, apiPath: apiPath, parameters: nil)
        
        // Build request
        let headers: [String: String] = [
            Constants.XParseApplicationIDKey: Constants.XParseApplicationIDValue,
            Constants.XParseRESTAPIKey: Constants.XParseRESTAPIValue,
            Constants.ContentTypeKey: Constants.ContentTypeValue
        ]
        let jsonBody = "{" +
            "\"\(Constants.JSONResponseKeys.StudentUniqueKey)\": \"\(s.uniqueKey!)\""   + "," +
            " \"\(Constants.JSONResponseKeys.StudentFirstName)\": \"\(s.firstName!)\""  + "," +
            " \"\(Constants.JSONResponseKeys.StudentLastName)\": \"\(s.lastName!)\""    + "," +
            " \"\(Constants.JSONResponseKeys.StudentMapString)\": \"\(s.mapString!)\""  + "," +
            " \"\(Constants.JSONResponseKeys.StudentMediaURL)\": \"\(s.mediaURL!)\""    + "," +
            " \"\(Constants.JSONResponseKeys.StudentLatitude)\": \(s.latitude!)"        + "," +
            " \"\(Constants.JSONResponseKeys.StudentLongitude)\": \(s.longitude!)"      +
        "}"
        print(jsonBody)
        let request = configureRequest(url: URL, methodType: Constants.Methods.MethodPUT, headers: headers, jsonBody: jsonBody)
        
        // Make the request
        makeNetworkRequest(request: request, ignoreInitialCharacters: false)
        {
            (results: AnyObject?, error: Error?)->Void in
            
            // Check for error
            guard (error == nil) else
            {
                print(error!)
                
                if((error! as NSError).domain == "noInternetConnection")
                {
                    completionHandler(false, nil,"No Internet Connection")
                }
                else
                {
                    completionHandler(false, nil, "Invalid Object ID")
                }
                
                return
            }
            
            print(results!)
            let updatedAt = results?[Constants.JSONResponseKeys.StudentUpdatedAt] as! String
            let success = true
            let errorString: String? = nil
            completionHandler(success, updatedAt, errorString)
        }
    }
    
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String?
    {
        if method.range(of: "{\(key)}") != nil
        {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        }
        else
        {
            return nil
        }
    }
}
