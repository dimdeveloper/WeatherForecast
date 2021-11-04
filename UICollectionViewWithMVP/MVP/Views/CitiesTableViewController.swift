//
//  CitiesTableViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 22.09.2021.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func textFieldTyping(_ sender: UITextField) {
        
        if searchTextField.text?.isEmpty == true {
            self.citiesList.removeAll()
            citiesList = defaultCitiesList
            self.cities = self.citiesList.keys.sorted()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            self.citiesList.removeAll()
            City.fetchCities(searchText: searchTextField.text) { citiesArray in
                for city in citiesArray {
                    print(city.cityName)
                    self.citiesList[city.cityName] = city.key
                }
                print(self.citiesList)
                self.cities = self.citiesList.keys.sorted()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    var defaultCitiesList: [String : String] = ["Львів" : "324561",
                                                "Київ" : "324505",
                                                "Івано-Франківськ" : "323684",
                                                "Тернопіль" : "325936",
                                                "Харків" : "323903",
                                                "Вінниця" : "326175",
                                                "Рівне" : "325590",
                                                "Луцьк" : "326220",
                                                "Хмельницький" : "324159",
                                                "Дніпро" : "322722",
                                                "Чернівці" : "322253",
                                                "Одеса" : "325343",
                                                "Запоріжжя" : "326514",
                                                "Черкаси" : "321985",
                                                "Житомир" : "326609",
                                                "Полтава" : "325523",
                                                "Миколаїв" : "324986",
                                                "Кропивницький" : "324291",
                                                "Суми" : "325825",
                                                "Ужгород" : "326310",
                                                "Чернігів" : "322162",
                                                "Херсон" : "324056",
                                                "Донецьк" : "323030",
                                                "Луганськ" : "324763",
                                                "Сімферополь" : "322464"]
    var citiesList: [String : String] = [ : ]
    var cities: [String]!
    var choosedCity: String!
    var cityNumber: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesList = defaultCitiesList
        cities = citiesList.keys.sorted()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiCell", for: indexPath)
        print(indexPath.row)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let city = cell.textLabel?.text else {return}
        cityNumber = citiesList[city]
        choosedCity = city
        dismissViewController()
    }

    func dismissViewController(){
        if let navController = presentingViewController as? UINavigationController {
            let rootViewController = navController.topViewController as! ViewController
            rootViewController.cityCode = cityNumber
            rootViewController.cityName = choosedCity
        } else {
            print("Error")
        }
        dismiss(animated: true, completion: nil)
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
