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
            AppDelegate.showAlert(self, alertText: "Empty Email Or Password")
            return
        }
        else if (email.text! == "")
        {
            AppDelegate.showAlert(self, alertText: "Empty Email")
            return
        }
        else if(password.text! == "")
        {
            AppDelegate.showAlert(self, alertText: "Empty Password")
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
                       AppDelegate.showAlert(self, alertText: errorString!)
                    }
                }
            }
        }
    }
    
    func showStudentInfoControllers()
    {
        let controller: UINavigationController
        controller = storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        
        present(controller, animated: true, completion: nil)
    }
}
