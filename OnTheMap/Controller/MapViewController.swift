//
//  ViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/24/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        if(StudentsDatasource.sharedInstance().studentInfoArray == nil)
        {
            self.mapView.alpha = CGFloat(0.5)
            UdacityClient.sharedInstance().getStudentLocationNetworkRequest(uniqueKey: nil, limit: 100)
            {
                (_ success: Bool, _ studentInfoArray: [StudentInformation], _ errorString: String?)->Void in
                
                if(success)
                {
                    StudentsDatasource.sharedInstance().studentInfoArray = studentInfoArray
                    
                    performUIUpdatesOnMain
                        {
                            self.annotateMapView()
                    }
                }
                else
                {
                    print(errorString!)
                    
                    performUIUpdatesOnMain
                        {
                            AppDelegate.showAlert(self, alertText: errorString!)
                    }
                }
                
                performUIUpdatesOnMain
                    {
                        self.mapView.alpha = CGFloat(1.0)
                }
            }
        }
        else
        {
            annotateMapView()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "StudentLocationPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            AppDelegate.openURLInBrowser(urlString: view.annotation?.subtitle!)
        }
    }
    
    func annotateMapView()
    {
        for studentInfo in StudentsDatasource.sharedInstance().studentInfoArray!
        {
            // Create an annotation
            let annotation = MKPointAnnotation()
            
            let lat = CLLocationDegrees(studentInfo.latitude!)
            let long = CLLocationDegrees(studentInfo.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            annotation.coordinate = coordinate
            
            annotation.title = "\(studentInfo.firstName!) \(studentInfo.lastName!)"
            annotation.subtitle = studentInfo.mediaURL!
            
            self.mapView.addAnnotation(annotation)
        }
    }
}

