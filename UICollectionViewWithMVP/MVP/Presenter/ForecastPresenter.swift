//
//  ForecastPresenter.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation
import UIKit


protocol CurrentConditionPresenter: class {
    func presentCurrentConditionForecast(currentCondition: CurrentConditionModel)
    func presentHourlyForecast(hourlyForecastArray: [HourlyForecast])
}
protocol PresenterDelegate: class {
    func presentForecast(forecasts: [ForecastForDay])
}

class ForecastPresenter {
    weak var delegate: PresenterDelegate?
    weak var currentConditionDelegate: CurrentConditionPresenter?
    var daysForecasts5: [ForecastForDay] = []
    func updateView(locationID: String){
        ForecastModel.fetchForecast(locationID: locationID) { (forecast) in
            self.daysForecasts5 = forecast
            self.delegate?.presentForecast(forecasts: self.daysForecasts5)
        }
    }

    func updateCurrentConditionView(){
        CurrentConditionReturnObjects.fetchCurrentConditions { (currenCondition) in
            self.currentConditionDelegate?.presentCurrentConditionForecast(currentCondition: currenCondition)
        }
        HourlyForecastModel.fetchHourlyForecast { (hourlyForecast) in
            self.currentConditionDelegate?.presentHourlyForecast(hourlyForecastArray: hourlyForecast)
        }
        
    }
    
}
