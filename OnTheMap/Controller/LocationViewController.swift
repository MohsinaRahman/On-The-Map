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
        
        locationTextField.text = "San Diego"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        unsubscribeToKeyboardNotifications()
        
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        view.frame.origin.y -= getKeyBoardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        view.frame.origin.y = 0
    }
    
    func getKeyBoardHeight(_ notification: Notification)->CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func findOnTheMap(_ sender: Any)
    {
        if(locationTextField.text?.isEmpty)!
        {
            showLocationError(message: "Location cannot be empty")
            return
        }
        else
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
                            self.showLocationError(message: "Could not geocode \(self.locationTextField.text!)")
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
    
    
    func showLocationError(message: String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
