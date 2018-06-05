//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/25/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func logoutPressed(_ sender: Any)
    {
        UdacityClient.sharedInstance().makeLogoutNetworkRequest()
        {
            (_ success: Bool, _ sessionID: String?, _ expiration: String?, _ errorString: String?)->Void in
            
            if(success)
            {

                print("Session ID = \(sessionID!)")
                print("expiration = \(expiration!)")
                
                performUIUpdatesOnMain
                {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func addLocationPressed(_ sender: Any)
    {
        UdacityClient.sharedInstance().getStudentLocationNetworkRequest(uniqueKey: UdacityClient.sharedInstance().accountID, limit: nil)
        {
            (_ success: Bool, _ studentInfoArray: [StudentInformation], _ errorString: String?)->Void in
            
                if(success)
                {
                    if(!studentInfoArray.isEmpty)
                    {
                        self.showOVerwriteAlert()
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "segueToLocation", sender: self)
                    }
                }
        }
        
    }
    
    func showOVerwriteAlert()
    {
        let alert = UIAlertController(title: nil, message: "You already have posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { _ in self.performSegue(withIdentifier: "segueToLocation", sender: self)}))

        
        self.present(alert, animated: true)
    }
}
