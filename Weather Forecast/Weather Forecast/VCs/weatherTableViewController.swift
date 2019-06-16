//
//  weatherTableViewController.swift
//  Weather Forecast
//
//  Created by Roy Akash on 18/05/19.
//  Copyright © 2019 The Roy Akash Software, Company. All rights reserved.
//

import UIKit
import CoreLocation

class weatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var forecastData = [Weather]()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateWeatherForLocation(location: "New Delhi")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        whatsNewIfNeeded()
    }
    
    func whatsNewIfNeeded(){
        let items = [WhatsNew.Item(
                    title: "All Week Weather",
                    subtitle: "Accurate Weather for the entire week, search across the World Over 170+ Countries",
                    image: UIImage(named: "sevenDayWeather")
                ),
                WhatsNew.Item(
                    title: "It's an Open Source",
                    subtitle: "Contributions to make the app better are very welcome 👨‍💻",
                    image: UIImage(named: "openSource")
                ),
                WhatsNew.Item(title: "No ads",
                              subtitle: "Full Ad free experience & will remain ad free forever",
                              image: UIImage(named: "adFree")
                ),
                WhatsNew.Item(title: "No Subscription Fee",
                              subtitle: "No Recurring Subscription Fee at all",
                              image: UIImage(named: "subs")
                ),
                WhatsNew.Item(title: "Browse anonymously",
                              subtitle: "User's Location is not required, Input location to acess weather for that week",
                              image: UIImage(named: "lock")
                ),
                WhatsNew.Item(title: "Dark Sky API", subtitle: "© Data from api.darksky.net", image: UIImage(named: "")
                )
        ]
        
        let theme = WhatsNewViewController.Theme {configuration in
            configuration.apply(animation: .slideUp)
            configuration.apply(theme: .darkRed)
        } 
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        let whatsnew = WhatsNew(title: "What's New in Weather Forecast", items: items)
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsnew, configuration: config, versionStore: keyValueVersionStore)
        
        if let VC = whatsNewVC{
            self.present(VC, animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty{
            // updateWeatherForLocation
            updateWeatherForLocation(location: locationString)
            
        }
    }
    
    func updateWeatherForLocation (location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        // Configuring the cell...
        let weatherObject = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        //cell.imageView?.image = UIImage(named: weatherObject.icon)
        //cell.imageView?.backgroundColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
