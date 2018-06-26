# On-The-Map 
# Project Summary
Built an app that gives the users to be able to see the location and an attached link of their friends/family. It can be used to find other’s location and a relevant URL for something interesting such as, homepage of historic site, Facebook page of a business, LinkedIn profile of a person etc. App has a map containing pins, where users can add their own data by posting a string reverse geo-codable to a location and a URL.

# App functionalities
### LoginViewController: 
In this viewController, users log in to the app using their Udacity username and password. After login, the app will attempt to authenticate with Udacity’s servers. If the login does not succeed, alert view automatically show the error massage if either email or password are incorrect.
### MapViewController:
MapViewController shows the pins last 100 locations posted by the other students. The locations are specified with a string and forward geocoded. They can be as specific as a full street address or as generic as “New York” or “San Diego, CA”
### ListViewController:
listViewController displays the most latest 100 locations and link posted by other students in a tableView settings. By tapping on the raw, user can see the associated link.
### PinViewController:
In this viewControler, users can post or put their own data in two steps. Adding the location and the link.
# Tools
* MapKit
* UITableViewController
* UICollectionViewController
* JSON parsing
# Requirements
* Xcode 9
* Swift 4.0
