//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 4/27/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var locationTextField: UITextField!
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationTextField.delegate = self
        
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.yellow
        self.view.addSubview(activityIndicator)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func findOnTheMap(_ sender: Any)
    {
        let g = CLGeocoder()
        activityIndicator.startAnimating()
        g.geocodeAddressString(locationTextField.text!)
        {
            (placemarks:[CLPlacemark]?, error: Error?)->() in
                performUIUpdatesOnMain
                {
                    self.activityIndicator.stopAnimating()
                    if error != nil
                    {
                        AppDelegate.showAlert(self, alertText: "Could not geocode \(self.locationTextField.text!)")
                        return
                    }
                    
                    if placemarks!.count > 0
                    {
                        print(placemarks!.count)
                        let placemark = placemarks![0]
                        let location = placemark.location
                        self.coordinate = location!.coordinate
                        
                        self.performSegue(withIdentifier: "locationSegue", sender: self)
                    }
                }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller: LinkShareViewController = segue.destination as! LinkShareViewController
        
        controller.lat = coordinate.latitude
        controller.long = coordinate.longitude
        controller.mapString = locationTextField.text!
    }
}
