//
//  OneDayTableViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 15.09.2021.
//

import UIKit

class OneDayTableViewController: UITableViewController {

    // Day Labels
    @IBOutlet weak var imageOfDayForecast: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var dayDescriptionForecast: UILabel!
    @IBOutlet weak var dayPrecipitationProbability: UILabel!
    @IBOutlet weak var dayWindSpeed: UILabel!
    @IBOutlet weak var dayWindDirection: UILabel!
    
    // Night Labels
    @IBOutlet weak var imageOfNightForecast: UIImageView!
    @IBOutlet weak var maxTempNight: UILabel!
    @IBOutlet weak var nightDescriptionForecast: UILabel!
    @IBOutlet weak var nightPrecipitationProbability: UILabel!
    @IBOutlet weak var nightWindSpeed: UILabel!
    @IBOutlet weak var nightWindDirection: UILabel!
    
    var indexPath: IndexPath!
    let presenter = ForecastPresenter()
    var forecast: ForecastForDay!
    var arrayOForecast = [ForecastForDay]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(with: forecast)
    }

    func updateView(with forecast: ForecastForDay){
        self.title = forecast.date
        imageOfDayForecast.image = UIImage(named: forecast.dayIcon)
        maxTemp.text = forecast.maxTemp
        dayDescriptionForecast.text = forecast.dayDescription
        dayPrecipitationProbability.text = forecast.dayPrecipitationProbability
        dayWindSpeed.text = forecast.dayWindSpeed
        dayWindDirection.text = forecast.dayWindDirection
        nightWindSpeed.text = forecast.nightWindSpeed
        nightWindDirection.text = forecast.nightWindDirection
        imageOfNightForecast.image = UIImage(named: forecast.nightIcon)
        maxTempNight.text = forecast.minTemp
        nightDescriptionForecast.text = forecast.nightDescription
        nightPrecipitationProbability.text = forecast.nightPrecipitationProbability
        
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.backgroundColor = .systemTeal
        } else {
        cell.backgroundColor = .black
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1):
            return 250
        default:
            return 44
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        let dayLAbel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: headerView.frame.height))
                dayLAbel.font = .systemFont(ofSize: 20)
        if section == 0 {
            dayLAbel.text = "День"
            dayLAbel.textColor = .black
            headerView.backgroundColor = .systemTeal
            headerView.addSubview(dayLAbel)
        } else {
            dayLAbel.text = "Ніч"
            dayLAbel.textColor = .white
            headerView.backgroundColor = .black
            headerView.addSubview(dayLAbel)
        }
        headerView.layer.cornerRadius = 10
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}
