//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/2/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        email.text = "nabila.rahman55@yahoo.com"
        password.text = "Ashiq888"
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func logInPressed(_ sender: Any)
    {
        if (email.text! == "" && password.text! == "")
        {
            showAlert(alertText: "Empty Email Or Password")
            return
        }
        else if (email.text! == "")
        {
            showAlert(alertText: "Empty Email")
            return
        }
        else if(password.text! == "")
        {
            showAlert(alertText: "Empty Password")
            return
        }
        else
        {
            print(email.text!)
            print(password.text!)
            UdacityClient.sharedInstance().makeLoginNetworkRequest(username: email.text!, password: password.text!)
            {
                (_ success: Bool, _ accountID: String?, _ sessionID: String?, _ errorString: String?)->Void in
                
                if(success)
                {
                    print("Account ID = \(accountID!)")
                    print("Session ID = \(sessionID!)")
                    
                    UdacityClient.sharedInstance().accountID = accountID
                    UdacityClient.sharedInstance().sessionID = sessionID
                    
                    performUIUpdatesOnMain
                    {
                            self.showStudentInfoControllers()
                    }
                }
                else
                {
                    performUIUpdatesOnMain
                    {
                        self.showAlert(alertText: "Invalid Email or Password")
                    }
                    
                }
            }
        }
    }
    
    func showAlert(alertText:String)
    {
        let controller = UIAlertController()
        controller.message = alertText
        
        let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default)
        {
            action in self.dismiss(animated: true, completion: nil)
            
        }
        controller.addAction(okAction)
        present (controller, animated: true, completion:nil)
    }
    
    func showStudentInfoControllers()
    {
        
        let controller: UINavigationController
        controller = storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        
        present(controller, animated: true, completion: nil)
    }
    
    
   
}
