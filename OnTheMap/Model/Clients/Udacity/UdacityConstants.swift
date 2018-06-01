//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/14/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation
extension UdacityClient
{
    struct Constants
    {
        
        static let ApiScheme = "https"
        
        static let ApiHostUdacityAccount = "www.udacity.com"
        static let ApiPathUdacityAccount = "/api/session"
        static let HeaderAcceptKey = "Accept"
        static let HeaderAcceptValue = "application/json"
        static let ContentTypeKey = "Content-Type"
        static let ContentTypeValue = "application/json"
        
        static let ApiHostStudentLocation = "parse.udacity.com"
        static let ApiPathStudentLocation = "/parse/classes/StudentLocation"
        static let XParseApplicationIDKey = "X-Parse-Application-Id"
        static let XParseApplicationIDValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let XParseRESTAPIKey = "X-Parse-REST-API-Key"
        static let XParseRESTAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONResponseKeys
        
    {
        static let LoginAccountKey = "account"
        static let LoginAccountRegisteredKey = "registered"
        static let LoginAccountIdKey = "key"
        static let LoginSessionKey = "session"
        static let LoginSessionIDKey = "id"
        static let LoginSessionExpirationKey = "expiration"
        
    }
    
    
    
    
    
    
    
    
    
}

