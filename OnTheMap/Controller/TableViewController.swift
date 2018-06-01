//
//  TableViewController.swift
//  OnTheMap
//
//  Created by mohsina rahman on 5/21/18.
//  Copyright © 2018 mohsina rahman. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if UdacityClient.sharedInstance().studentInfoArray != nil
        {
            return (UdacityClient.sharedInstance().studentInfoArray?.count)!

        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        
        let s = UdacityClient.sharedInstance().studentInfoArray![indexPath.row]
        
        cell.textLabel?.text = "\(s.firstName!) \(s.lastName!)"
        cell.detailTextLabel?.text = s.mediaURL!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let app = UIApplication.shared
        if let toOpen = UdacityClient.sharedInstance().studentInfoArray?[indexPath.row].mediaURL!
        {
            app.openURL(URL(string: toOpen)!)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


}
