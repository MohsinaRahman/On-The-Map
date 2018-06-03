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
        static let ApiPathUdacitySession = "/api/session"
        static let ApiPathUdacityUserData = "/api/users/{id}"
        static let HeaderAcceptKey = "Accept"
        static let HeaderAcceptValue = "application/json"
        static let ContentTypeKey = "Content-Type"
        static let ContentTypeValue = "application/json"
        static let HeaderXXSRFTokenKey = "X-XSRF-TOKEN"
        
        static let ApiHostStudentLocation = "parse.udacity.com"
        static let ApiPathStudentLocation = "/parse/classes/StudentLocation"
        static let XParseApplicationIDKey = "X-Parse-Application-Id"
        static let XParseApplicationIDValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let XParseRESTAPIKey = "X-Parse-REST-API-Key"
        static let XParseRESTAPIValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        struct Methods
        {
            static let MethodGET = "GET"
            static let MethodPUT = "PUT"
            static let MethodPOST = "POST"
            static let MethodDELETE = "DELETE"
        }
        
        struct JSONResponseKeys
        {
            static let LoginAccountKey = "account"
            static let LoginAccountRegisteredKey = "registered"
            static let LoginAccountIdKey = "key"
            static let LoginSessionKey = "session"
            static let LoginSessionIDKey = "id"
            static let LoginSessionExpirationKey = "expiration"
            
            static let StudentUniqueKey = "uniqueKey"
            static let StudentObjectId  = "objectId"
            static let StudentMapString = "mapString"
            static let StudentLastName  = "lastName"
            static let StudentFirstName = "firstName"
            static let StudentMediaURL  = "mediaURL"
            static let StudentCreatedAt = "createdAt"
            static let StudentUpdatedAt = "updatedAt"
            static let StudentLatitude   = "latitude"
            static let StudentLongitude = "longitude"
        }
    }
}
