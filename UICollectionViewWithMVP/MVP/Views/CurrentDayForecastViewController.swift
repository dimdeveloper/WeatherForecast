//
//  CurrentDayForecastViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 06.09.2021.
//

import UIKit

class CurrentDayForecastViewController: UITableViewController, CurrentConditionPresenter {
    
    

    var currentCondition: CurrentConditionModel?
    var hourlyForecast = [HourlyForecast]()
    let presenter = ForecastPresenter()
    var cityCode: String!
    @IBOutlet weak var humidityStackView: UIStackView!
    @IBOutlet weak var windStackView: UIStackView!
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var headerView: UITableViewHeaderFooterView!
    @IBOutlet weak var descriptionForecast: UILabel!
    @IBOutlet weak var headerColorView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.currentConditionDelegate = self
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        headerColorView.layer.cornerRadius = 10.0
        extendedLayoutIncludesOpaqueBars = true
        presenter.updateCurrentConditionView(with: cityCode)
        self.navigationController?.navigationBar.sizeToFit()
        
    }
   // making tableViewHeader change height Dynamically
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = headerView else {return}
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
        }
        
        
    }
    
// update model
    func presentCurrentConditionForecast(currentCondition: CurrentConditionModel) {
        self.currentCondition = currentCondition
        DispatchQueue.main.async {
            self.title = currentCondition.date
            self.updateView()
            self.tableView.reloadData()
        }
    }
    
// update hourly forecast
    func presentHourlyForecast(hourlyForecastArray: [HourlyForecast]) {
        self.hourlyForecast = hourlyForecastArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateView(){
        guard let conditions = currentCondition else {return}
        print(conditions)
        forecastImage.image = UIImage(named: conditions.icon)
        tempLabel.text = "\(conditions.temperature)ºC"
        windSpeed.text = "Швидкість \(conditions.windSpeed)" + " км\\г"
        windDirection.text = "Напрямок \(conditions.windDirection)"
        humidityLabel.text = "Вологість \(conditions.humidity)%"
        descriptionForecast.text = conditions.currentConditionTitle
        if conditions.hasPrecipitation {
            precipitationLabel.text = conditions.precipitationType
        } else {
            precipitationLabel.text = "Без опадів"
        }
//        humidityStackView.layer.cornerRadius = 10
//        windStackView.layer.cornerRadius = 10
//        descriptionForecast.layer.masksToBounds = true
//        precipitationLabel.layer.masksToBounds = true
//        descriptionForecast.layer.cornerRadius = 10
//        precipitationLabel.layer.cornerRadius = 10
    }
}

extension CurrentDayForecastViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hourlyForecast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourForecastCell", for: indexPath) as! HourlyForecastTableViewCell
        if indexPath == IndexPath(row: 0, section: 0) {
            var separatorsView: [UIView] = []
            for view in cell.subviews where String(describing: type(of: view)).hasSuffix("SeparatorView") {
                separatorsView.append(view)
            }
            separatorsView.last?.removeFromSuperview()
        }
        cell.dateLabel.text = hourlyForecast[indexPath.row].time
        cell.temperatureLabel.text = "\(hourlyForecast[indexPath.row].temperature)ºC"
        cell.imageForecast.image = UIImage(named: hourlyForecast[indexPath.row].weatherIcon)
        if hourlyForecast[indexPath.row].hasPrecipitation {
            cell.precipitationLabel.text = hourlyForecast[indexPath.row].precipitationType
        } else {
            cell.precipitationLabel.text = "Без опадів"
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
        
        return cell
    }
    

    
    
}
