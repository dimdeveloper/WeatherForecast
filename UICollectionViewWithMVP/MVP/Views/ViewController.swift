//
//  ViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 01.09.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PresenterDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var forecastsCollectionView: UICollectionView!
    @IBOutlet weak var cellContainerView: UIView!
    var oneDayForecast: ForecastForDay!
    let presenter = ForecastPresenter()
    var forecasts5DayArray: [ForecastForDay] = []
    let refreshControl = UIRefreshControl()
    var cityName: String = "Вінниця"
    var cityCode: String = "326175"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cityName
        presenter.delegate = self
        forecastsCollectionView.delegate = self
        forecastsCollectionView.dataSource = self
//        let collectionViewLayout = ForecastCollectionViewLayout()
//        
//        forecastsCollectionView.collectionViewLayout = collectionViewLayout
        forecastsCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 17)]
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлюю...", attributes: attributes)
        showActivityIndicator()
        
//        let indicatorView = self.activityIndicator(style: UIActivityIndicatorView.Style.large, center: self.view.center)
//        self.view.addSubview(indicatorView)
//        indicatorView.startAnimating()
        
        presenter.updateView(locationID: cityCode)
        //showActivityIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = cityName
        //showActivityIndicator()
        //presenter.updateView(locationID: cityCode)
    }
    func presentForecast(forecasts: [ForecastForDay]) {
        self.forecasts5DayArray = forecasts
        DispatchQueue.main.async {
            self.forecastsCollectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.stopActivityIndicator()
        }
    }
    @objc func refreshWeatherData(){
        presenter.updateView(locationID: cityCode)
    }
//    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium, frame: CGRect? = nil, center: CGPoint? = nil) -> UIActivityIndicatorView {
//        let activityIndicatorView = UIActivityIndicatorView(style: style)
//        if let frame = frame {
//            activityIndicatorView.frame = frame
//        }
//        if let center = center {
//            activityIndicatorView.center = center
//        }
//        return activityIndicatorView
//    }
    func showActivityIndicator(){
        let container: UIView = UIView()
        container.tag = 100
        container.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        container.backgroundColor = .white
        container.layer.opacity = 0.5
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
    }
    func stopActivityIndicator(){
        for view in self.view.subviews {
            if view.tag == 100 {
                view.removeFromSuperview()
            }
        }
    }
    func setConstraintsCellSubviewsForToday(cell: ForecastCollectionViewCell){
        cell.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.precipitationPropabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            cell.dateLabel.trailingAnchor.constraint(equalTo: cell.cellDescriptionContainerView.trailingAnchor, constant: -10),
            cell.dateLabel.topAnchor.constraint(equalTo: cell.cellDescriptionContainerView.topAnchor, constant: 10),
            cell.temperatureLabel.centerXAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerXAnchor),
            cell.temperatureLabel.centerYAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerYAnchor, constant: -10),
            cell.descriptionLabel.centerXAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerXAnchor),
            cell.descriptionLabel.bottomAnchor.constraint(equalTo: cell.precipitationPropabilityLabel.topAnchor, constant: -10),
            cell.precipitationPropabilityLabel.centerXAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerXAnchor),
            cell.precipitationPropabilityLabel.bottomAnchor.constraint(equalTo: cell.cellDescriptionContainerView.bottomAnchor, constant: -18)
        ])
        
        
    }
    func setConstraintsCellSubviews(cell: ForecastCollectionViewCell){

        cell.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.dateLabel.trailingAnchor.constraint(equalTo: cell.cellDescriptionContainerView.trailingAnchor, constant: -10),
            cell.dateLabel.topAnchor.constraint(equalTo: cell.cellDescriptionContainerView.topAnchor, constant: 10),
            cell.temperatureLabel.centerXAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerXAnchor),
            cell.temperatureLabel.centerYAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerYAnchor),
            cell.descriptionLabel.centerXAnchor.constraint(equalTo: cell.cellDescriptionContainerView.centerXAnchor),
            cell.descriptionLabel.bottomAnchor.constraint(equalTo: cell.cellDescriptionContainerView.bottomAnchor, constant: -10),
        
        ])
        
        
    }
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
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
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionViewCell
        cell.updateCell()
//        cell.parentCellStackView.translatesAutoresizingMaskIntoConstraints = false
//        cell.parentCellStackView.widthAnchor.constraint(equalToConstant: collectionView.bounds.inset(by: collectionView.layoutMargins).width).isActive = true
        cell.layer.cornerRadius = 10.0
        cell.dateLabel.text = forecasts5DayArray[indexPath.row].date
        cell.temperatureLabel.text = "\(forecasts5DayArray[indexPath.row].maxTemp)ºC / \(forecasts5DayArray[indexPath.row].minTemp)ºC"
        cell.temperatureLabel.font = indexPath == IndexPath(row: 0, section: 0) ? UIFont.systemFont(ofSize: 35) :  UIFont.systemFont(ofSize: 20)
        cell.descriptionLabel.text = forecasts5DayArray[indexPath.row].dayDescription
        cell.precipitationPropabilityLabel.text = "Ймовірність опадів \( forecasts5DayArray[indexPath.row].dayPrecipitationProbability)%"
        cell.imageForecast.image = UIImage(named: forecasts5DayArray[indexPath.row].dayIcon)
        
        if indexPath == IndexPath(row: 0, section: 0){
            cell.precipitationPropabilityLabel.isHidden = false
           // cell.thermometer.isHidden = false
            //setConstraintsCellSubviewsForToday(cell: cell)
            print("IndexPath of TODAY")
    } else {
        cell.precipitationPropabilityLabel.isHidden = true
       cell.thermometer.isHidden = true
 
        //setConstraintsCellSubviewsForToday(cell: cell)
        print("IndexPath of TODAY")
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
        
        let cellWidth = availableWidth.rounded(.down)
        return indexPath == IndexPath(row: 0, section: 0) ? CGSize(width: cellWidth, height: 180) : CGSize(width: cellWidth, height: 85)
    }
}
