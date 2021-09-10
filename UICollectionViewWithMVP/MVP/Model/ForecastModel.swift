//
//  ForecastModel.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation

let stringURL = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-ua&metric=true"

// Model
struct ForecastForDay {
    let date: String
    let minTemp: String
    let maxTemp: String
    let icon: String
    
    init(date: String, minTemp: String, maxTemp: String, icon: Int32){
        
        self.date = date
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.icon = String(icon)
    }
    
}

// Fetching model structure
struct ForecastModel: Codable {
    let dailyForecasts: [DayForecast]
    enum CodingKeys: String, CodingKey {
        case dailyForecasts = "DailyForecasts"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.dailyForecasts = try valueContainer.decode([DayForecast].self, forKey: CodingKeys.dailyForecasts)
    }
    
}
struct DayForecast: Codable {
    let date: String
    let epochDate: Int64
    let temperature: Temperature
    let day: Day
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case epochDate = "EpochDate"
        case temperature = "Temperature"
        case day = "Day"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
        self.epochDate = try valueContainer.decode(Int64.self, forKey: CodingKeys.epochDate)
        self.temperature = try valueContainer.decode(Temperature.self, forKey: CodingKeys.temperature)
        self.day = try valueContainer.decode(Day.self, forKey: CodingKeys.day)
        
    }
}
struct Temperature: Codable {
    let minimum: Values
    let maximum: Values
    
    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.minimum = try valueContainer.decode(Values.self, forKey: CodingKeys.minimum)
        self.maximum = try valueContainer.decode(Values.self, forKey: CodingKeys.maximum)
    }
}
struct Values: Codable {
    let value: Double
    let unit: String
    let unitType: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
        self.unit = try valueContainer.decode(String.self, forKey: CodingKeys.unit)
        self.unitType = try valueContainer.decode(Double.self, forKey: CodingKeys.unitType)
        
    }
}
struct Day: Codable {
//    "Icon": 3,
//            "IconPhrase": "Місцями сонячно",
//            "HasPrecipitation": false
    let icon: Int32
    let iconPhrase: String
    let precipitation: Bool
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case precipitation = "HasPrecipitation"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.icon = try valueContainer.decode(Int32.self, forKey: CodingKeys.icon)
        self.iconPhrase = try valueContainer.decode(String.self, forKey: CodingKeys.iconPhrase)
        self.precipitation = try valueContainer.decode(Bool.self, forKey: CodingKeys.precipitation)
        
    }
}

extension ForecastModel {
    static func fetchForecast(completion: @escaping(ForecastModel) -> Void){
        let basicURL = URL(string: stringURL)!
        let task = URLSession.shared.dataTask(with: basicURL) { (data, responce, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let forecast = try? jsonDecoder.decode(ForecastModel.self, from: data) {
             completion(forecast)
            } else {
                print("Error retreiving data")
            }
        }
        task.resume()
    }
    

}
