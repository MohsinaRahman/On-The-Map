//
//  UdacityStudentLocation.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/18/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

struct StudentInformation
{
    var uniqueKey: String?
    var objectId: String?
    var mapString: String?
    var lastName: String?
    var firstName: String?
    var mediaURL: String?
    var createdAt: String?
    var updatedAt: String?
    var latitude: Double?
    var longitude: Double?
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double)
    {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init (student: [String: AnyObject])
    {
        uniqueKey = student[UdacityClient.Constants.JSONResponseKeys.StudentUniqueKey] as? String
        objectId = student[UdacityClient.Constants.JSONResponseKeys.StudentObjectId] as? String
        mapString = student[UdacityClient.Constants.JSONResponseKeys.StudentMapString] as? String
        lastName = student[UdacityClient.Constants.JSONResponseKeys.StudentLastName] as? String
        firstName = student[UdacityClient.Constants.JSONResponseKeys.StudentFirstName] as? String
        mediaURL = student[UdacityClient.Constants.JSONResponseKeys.StudentMediaURL] as? String
        createdAt = student[UdacityClient.Constants.JSONResponseKeys.StudentCreatedAt] as? String
        updatedAt = student[UdacityClient.Constants.JSONResponseKeys.StudentUpdatedAt] as? String
        latitude = student[UdacityClient.Constants.JSONResponseKeys.StudentLatitude] as? Double
        longitude = student[UdacityClient.Constants.JSONResponseKeys.StudentLongitude] as? Double
    }
    
    func isValid() -> Bool
    {
        let result = uniqueKey != nil && objectId != nil && mapString != nil && lastName != nil && firstName != nil && mediaURL != nil && createdAt != nil && updatedAt != nil && latitude != nil && longitude != nil
        
        return result
    }
}
