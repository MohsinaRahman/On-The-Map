//
//  ViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/24/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController,MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        let regionRadius: CLLocationDistance = 1000
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // Create an annotation
        var annotation = MKPointAnnotation()

        let lat = CLLocationDegrees(21.283)
        let long = CLLocationDegrees(-157.823)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        annotation.coordinate = coordinate
        annotation.title = "Mohsina Rahman"
        annotation.subtitle = "www.google.com"
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "Pin1"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    
    }
   
}

