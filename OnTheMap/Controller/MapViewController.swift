//
//  ViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/24/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController,MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.alpha = CGFloat(0.5)
        UdacityClient.sharedInstance().getStudentLocationNetworkRequest()
        {
            (_ success: Bool, _ studentInfoArray: [StudentInformation], _ errorString: String?)->Void in
            
                if(success)
                {
                    UdacityClient.sharedInstance().studentInfoArray = studentInfoArray
                    self.mapView.delegate = self
                    
                    performUIUpdatesOnMain
                    {
                        for studentInfo in UdacityClient.sharedInstance().studentInfoArray!
                        {
                            // Create an annotation
                            let annotation = MKPointAnnotation()
                            
                            let lat = CLLocationDegrees(studentInfo.latitude!)
                            let long = CLLocationDegrees(studentInfo.longitude!)
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            /*
                             if(!initialRegionSet)
                             {
                             let regionRadius: CLLocationDistance = 1000
                             let initialLocation = CLLocation(latitude: lat, longitude: long)
                             let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                             regionRadius, regionRadius)
                             self.mapView.setRegion(coordinateRegion, animated: true)
                             initialRegionSet = true
                             }
                             */
                            annotation.coordinate = coordinate
                            
                            annotation.title = "\(studentInfo.firstName!) \(studentInfo.lastName!)"
                            annotation.subtitle = studentInfo.mediaURL!
                            
                            self.mapView.addAnnotation(annotation)
                        }
                        self.mapView.alpha = CGFloat(1.0)
                    }
                }
                else
                {
                    print(errorString!)
                }
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "Pin1"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!
            {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
   
}

