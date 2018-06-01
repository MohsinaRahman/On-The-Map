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
    
    init (student: [String: AnyObject])
    {
        uniqueKey = student["uniqueKey"] as? String
        objectId = student["objectId"] as? String
        mapString = student["mapString"] as? String
        lastName = student["lastName"] as? String
        firstName = student["firstName"] as? String
        mediaURL = student["mediaURL"] as? String
        createdAt = student["createdAt"] as? String
        updatedAt = student["updatedAt"] as? String
        latitude = student["latitude"] as? Double
        longitude = student["longitude"] as? Double
    }
    
    func isValid() -> Bool
    {
        var result = uniqueKey != nil && objectId != nil && mapString != nil && lastName != nil && firstName != nil && mediaURL != nil && createdAt != nil && updatedAt != nil && latitude != nil && longitude != nil
        
        return result
    }
}
