//
//  StudentDatasource.swift
//  OnTheMap
//
//  Created by mohsina rahman on 6/5/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import Foundation

class StudentsDatasource
{
    var studentInfoArray :[StudentInformation]? = nil
    
    class func sharedInstance() -> StudentsDatasource
    {
        struct Singleton
        {
            static var sharedInstance = StudentsDatasource()
        }
        return Singleton.sharedInstance
    }
}
