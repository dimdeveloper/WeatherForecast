//
//  ViewController.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 01.09.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PresenterDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var forecastsCollectionView: UICollectionView!
    
    let presenter = ForecastPresenter()
    var forecasts5DayArray: [ForecastForDay] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вінниця"
        presenter.delegate = self
        forecastsCollectionView.delegate = self
        forecastsCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        presenter.updateView()
        presenter.updateCurrentConditionView()
        
        
    }
    func presentForecast(forecasts: [ForecastForDay]) {
        self.forecasts5DayArray = forecasts
        DispatchQueue.main.async {
            self.forecastsCollectionView.reloadData()
            print(self.forecasts5DayArray)
        }
    }

}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                performSegue(withIdentifier: "CurrentConditionSegue", sender: nil)
            
            default: break
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts5DayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionViewCell
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 10.0
        cell.dateLabel.text = forecasts5DayArray[indexPath.row].date
        cell.temperatureLabel.text = "\(forecasts5DayArray[indexPath.row].minTemp) / \(forecasts5DayArray[indexPath.row].maxTemp)"
        cell.imageForecast.image = UIImage(named: forecasts5DayArray[indexPath.row].icon)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        let cellWidth = availableWidth.rounded(.down)
        return indexPath == IndexPath(row: 0, section: 0) ? CGSize(width: cellWidth, height: 150) : CGSize(width: cellWidth, height: 85)
    }
}
