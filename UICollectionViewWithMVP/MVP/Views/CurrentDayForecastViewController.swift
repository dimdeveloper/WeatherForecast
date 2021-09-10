//
//  CurrentDayForecastViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 06.09.2021.
//

import UIKit

class CurrentDayForecastViewController: UIViewController, CurrentConditionPresenter {
    
    
    @IBOutlet weak var hourForecastTableView: UITableView!
    
    
    var currentCondition: CurrentConditionModel?
    var hourlyForecast = [HourlyForecast]()
    let presenter = ForecastPresenter()
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.currentConditionDelegate = self
        hourForecastTableView.delegate = self
        hourForecastTableView.dataSource = self
        presenter.updateCurrentConditionView()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 950)
    }
    
// update model
    func presentCurrentConditionForecast(currentCondition: CurrentConditionModel) {
        self.currentCondition = currentCondition
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
// update hourly forecast
    func presentHourlyForecast(hourlyForecastArray: [HourlyForecast]) {
        self.hourlyForecast = hourlyForecastArray
        DispatchQueue.main.async {
            self.hourForecastTableView.reloadData()
        }
    }

    func updateView(){
        guard let conditions = currentCondition else {return}
//        tempLabel.text = conditions.temperature
//        windLabel.text = conditions.wind
//        humidityLabel.text = conditions.humidity
    }
}

extension CurrentDayForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hourlyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourForecastCell", for: indexPath) as! HourlyForecastTableViewCell
        cell.dateLabel.text = hourlyForecast[indexPath.row].time
        cell.temperatureLabel.text = hourlyForecast[indexPath.row].temperature
        
        return cell
    }
    
    
    
}
