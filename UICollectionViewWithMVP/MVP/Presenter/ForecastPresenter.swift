//
//  ForecastPresenter.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation

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
    func updateView(){
        var daysForecasts5: [ForecastForDay] = []
        ForecastModel.fetchForecast { (forecast) in
            let forecasts = forecast.dailyForecasts
            for dayForecast in forecasts {
                let appDateString = self.getDateString(stringDate: dayForecast.date)
                let forecastforDay = ForecastForDay(date: appDateString, minTemp: String(dayForecast.temperature.minimum.value), maxTemp: String(dayForecast.temperature.maximum.value), icon: dayForecast.day.icon)
                daysForecasts5.append(forecastforDay)
            }
            self.delegate?.presentForecast(forecasts: daysForecasts5)
        }
    }
    func updateCurrentConditionView(){
        CurrentConditionReturnObjects.fetchCurrentConditions { (currenCondition) in
             print(currenCondition)
            self.currentConditionDelegate?.presentCurrentConditionForecast(currentCondition: currenCondition)
        }
        HourlyForecastModel.fetchHourlyForecast { (hourlyForecast) in
            self.currentConditionDelegate?.presentHourlyForecast(hourlyForecastArray: hourlyForecast)
        }
        
    }
    func getDateString(stringDate: String) -> String {
            // input DateString Example from JSON responce: "2021-09-01T08:00:00+03:00"
        let jSONDateFormatter = DateFormatter()
        jSONDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jSONDateFormatter.calendar = Calendar(identifier: .iso8601)
        jSONDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        jSONDateFormatter.locale = Locale(identifier: "uk_UA_POSIX")
            // first convert to Date
        let date: Date = jSONDateFormatter.date(from: stringDate)!
        let aPPDateFormatter = DateFormatter()
        aPPDateFormatter.dateFormat = "MMM dd, yyyy"
            // then convert to my format String
        return aPPDateFormatter.string(from: date);
    }
    
    
}
