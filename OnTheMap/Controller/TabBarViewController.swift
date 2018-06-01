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
                    self.showlogin()
                }
                
            }
            else
            {
               
                
            }
        }
    }
    
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        
    }
    
    func showlogin()
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: "loginpageid") as! LogInViewController
        
        present(controller, animated: true, completion: nil)
    }
    
}
