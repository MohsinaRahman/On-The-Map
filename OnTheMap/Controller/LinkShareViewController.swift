//
//  LinkShareViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/27/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import MapKit

class LinkShareViewController:UIViewController,MKMapViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkShareTextField: UITextField!
    
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var mapString: String?
    var mediaURL: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let regionRadius: CLLocationDistance = 1000
        let initialLocation = CLLocation(latitude:lat, longitude:long)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.delegate = self
        mapView.setRegion(coordinateRegion, animated: true)
        annotateMapView()
    
        linkShareTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func submitPressed(_ sender: Any)
    {
        let link = self.linkShareTextField.text!
        
        if self.linkShareTextField.text!.isEmpty
        {
            showLinkShareError(message: "Linkshare cannot be empty!")
            return
        }
        
        UdacityClient.sharedInstance().getStudentLocationNetworkRequest(uniqueKey: UdacityClient.sharedInstance().accountID)
        {
            (_ success: Bool, _ studentInfoArray: [StudentInformation], _ errorString: String?)->Void in
            
            if(success)
            {
                if(studentInfoArray.isEmpty)
                {
                    // No student found with the given id, need to do a POST reqeust
                    UdacityClient.sharedInstance().getPublicUserDataNetworkRequest(uniqueKey: UdacityClient.sharedInstance().accountID!)
                    {
                        (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?)->Void in
                        
                        if(success)
                        {
                            // Create a new student
                            let s = StudentInformation(
                                uniqueKey: UdacityClient.sharedInstance().accountID!,
                                firstName: firstName!,
                                lastName: lastName!,
                                mapString: self.mapString!,
                                mediaURL: link,
                                latitude: self.lat,
                                longitude: self.long
                            )
                            
                            UdacityClient.sharedInstance().postStudentLocation(s: s)
                            {
                                (_ success: Bool, _ createdAt: String?, _ objectID: String?, _ errorString: String?)->Void in
                                
                                if(success)
                                {
                                    print("Created record for \(s.firstName!) \(s.lastName!) at \(createdAt!) - object ID = \(objectID!)")
                                    
                                    performUIUpdatesOnMain
                                        {
                                            self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                                else
                                {
                                    print(errorString!)
                                }
                            }
                        }
                        else
                        {
                            print(errorString!)
                        }
                    }
                }
                else
                {
                    // Student found, do a PUT request
                    var s = studentInfoArray[0]
                    
                    s.latitude = self.lat
                    s.longitude = self.long
                    s.mapString = self.mapString
                    s.mediaURL = link
                    
                    UdacityClient.sharedInstance().putStudentLocation(s: s)
                    {
                        (_ success: Bool, _ updatedAt: String?, _ errorString: String?)->Void in
                        
                        if(success)
                        {
                            print("Updated record for \(s.firstName!) \(s.lastName!) at \(updatedAt!)")
                            
                            performUIUpdatesOnMain
                                {
                                    self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                        else
                        {
                            print(errorString!)
                        }
                    }
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
        let reuseId = "UserLocationPin"
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
    
    func annotateMapView()
    {
        // Create an annotation
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
        
        annotation.coordinate = coordinate
        annotation.title = "\(mapString!)"
        
        self.mapView.addAnnotation(annotation)
    }
    
    func showLinkShareError(message: String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
