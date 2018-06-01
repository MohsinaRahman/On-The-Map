//
//  LinkShareViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/27/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import MapKit


class LinkShareViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let regionRadius: CLLocationDistance = 1000
        let initialLocation = CLLocation(latitude:lat, longitude:long)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
      
    }
    
    

}
