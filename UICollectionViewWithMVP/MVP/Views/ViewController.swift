//
//  ViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 01.09.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PresenterDelegate, UICollectionViewDelegateFlowLayout {
    
    var topInset: CGFloat = 0
    @IBOutlet weak var forecastsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndication: UIActivityIndicatorView!
    var oneDayForecast: ForecastForDay!
    let presenter = ForecastPresenter()
    var forecasts5DayArray: [ForecastForDay] = []
    let refreshControl = UIRefreshControl()
    var cityName: String = "Вінниця" {
        didSet {
            title = cityName
            activityIndication.startAnimating()
            presenter.updateView(locationID: cityCode)
        }
    }
    var cityCode: String = "326175"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cityName
        presenter.delegate = self
        forecastsCollectionView.delegate = self
        forecastsCollectionView.dataSource = self
        refreshActivityIndicator()
        activityIndication.startAnimating()
        presenter.updateView(locationID: cityCode)
    }
    func refreshActivityIndicator(){
        forecastsCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 17)]
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлюю...", attributes: attributes)
    }
    func presentForecast(forecasts: [ForecastForDay]) {
            self.forecasts5DayArray = forecasts
            DispatchQueue.main.async {
                self.forecastsCollectionView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndication.stopAnimating()
            }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // fix large title appiaring after rotation
        self.navigationController?.navigationBar.sizeToFit()
    }
    @objc func refreshWeatherData(){
        presenter.updateView(locationID: cityCode)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // fix large title appiaring after back return from another view
        self.navigationController?.navigationBar.sizeToFit()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("Section Inset Reload!")
        return UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let collectionView = forecastsCollectionView else { return }
        let contentsize = collectionView.collectionViewLayout.collectionViewContentSize.height - topInset
        let collectionViewHeight = collectionView.bounds.height
        if collectionViewHeight > contentsize {
            topInset = (collectionViewHeight - contentsize)/2
        } else {
            topInset = 20
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                presenter.delegate?.cityCode = cityCode
                performSegue(withIdentifier: "CurrentConditionSegue", sender: nil)
            default:
                oneDayForecast = forecasts5DayArray[indexPath.row]
                performSegue(withIdentifier: "OneDaySegue", sender: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts5DayArray.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OneDaySegue" {
            let segueDestination = segue.destination as! OneDayTableViewController
            segueDestination.forecast = self.oneDayForecast
        }
        if segue.identifier == "CurrentConditionSegue" {
            let segueDestination = segue.destination as! CurrentDayForecastViewController
            segueDestination.cityCode = self.cityCode
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionViewCell
        cell.layer.cornerRadius = 10.0
        cell.dateLabel.text = forecasts5DayArray[indexPath.row].date
        cell.temperatureLabel.text = "\(forecasts5DayArray[indexPath.row].maxTemp)ºC / \(forecasts5DayArray[indexPath.row].minTemp)ºC"
        cell.temperatureLabel.font = indexPath == IndexPath(row: 0, section: 0) ? UIFont.systemFont(ofSize: 35) :  UIFont.systemFont(ofSize: 20)
        cell.descriptionLabel.text = forecasts5DayArray[indexPath.row].dayDescription
        cell.precipitationPropabilityLabel.text = "Ймовірність опадів \( forecasts5DayArray[indexPath.row].dayPrecipitationProbability)%"
        cell.imageForecast.image = UIImage(named: forecasts5DayArray[indexPath.row].dayIcon)
        cell.thermometer.isHidden = true
        if indexPath == IndexPath(row: 0, section: 0){
            cell.precipitationPropabilityLabel.isHidden = false
            cell.thermometer.isHidden = false
        } else {
            cell.precipitationPropabilityLabel.isHidden = true
            cell.thermometer.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
        let cellWidth = availableWidth.rounded(.down)
        return indexPath == IndexPath(row: 0, section: 0) ? CGSize(width: cellWidth, height: 180) : CGSize(width: cellWidth, height: 85)
    }
}
