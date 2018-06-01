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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationTextField.delegate = self

        
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func findOnTheMap(_ sender: Any)
    {
        let g = CLGeocoder()
        
        g.geocodeAddressString(locationTextField.text!)
        {
            (placemarks:[CLPlacemark]?, error: Error?)->() in
            if placemarks!.count > 0
            {
                print(placemarks!.count)
                let placemark = placemarks![0]
                let location = placemark.location
                self.coordinate = location!.coordinate
                print("Inside completion handler: \(self.coordinate)")
                self.performSegue(withIdentifier: "locationSegue", sender: self)
                
                /*let controller: LinkShareViewController
                controller = self.storyboard?.instantiateViewController(withIdentifier: "LinkShareViewController") as! LinkShareViewController
                
                controller.lat = coordinate.latitude
                controller.long = coordinate.longitude

                //self.present(controller, animated: true, completion: nil)*/

            }
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let controller: LinkShareViewController = segue.destination as! LinkShareViewController
        controller.lat = coordinate.latitude
        controller.long = coordinate.longitude
    }
    
    
}
