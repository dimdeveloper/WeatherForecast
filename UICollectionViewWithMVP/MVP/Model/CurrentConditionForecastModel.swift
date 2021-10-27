//
//  CurrentConditionForecastModel.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 06.09.2021.
//

import Foundation

 // request URL "http://dataservice.accuweather.com/currentconditions/v1/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&details=true"

public struct CurrentConditionModel {
    let date: String
    let temperature: String
    let humidity: String
    let windSpeed: String
    let windDirection: String
    let currentConditionTitle: String
    let icon: String
    let hasPrecipitation: Bool
    let precipitationType: String?
}

struct CurrentConditionReturnObjects: Codable {
    let date: String
    let dayOrNight: Bool
    let icon: Int32
    let temperature: CurrentTemperature
    let wind: CurrentConditionWind
    let humidity: Int32
    let text: String
    let hasPrecipitation: Bool
    let precipitationType: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "LocalObservationDateTime"
        case dayOrNight = "IsDayTime"
        case icon = "WeatherIcon"
        case temperature = "Temperature"
        case wind = "Wind"
        case humidity = "RelativeHumidity"
        case text = "WeatherText"
        case hasPrecipitation = "HasPrecipitation"
        case precipitationType = "PrecipitationType"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
        self.dayOrNight = try valueContainer.decode(Bool.self, forKey: CodingKeys.dayOrNight)
        self.humidity = try valueContainer.decode(Int32.self, forKey: CodingKeys.humidity)
        self.icon = try valueContainer.decode(Int32.self, forKey: CodingKeys.icon)
       self.temperature = try valueContainer.decode(CurrentTemperature.self, forKey: CodingKeys.temperature)
        self.text = try valueContainer.decode(String.self, forKey: CodingKeys.text)
        self.wind = try valueContainer.decode(CurrentConditionWind.self, forKey: CodingKeys.wind)
        self.hasPrecipitation = try valueContainer.decode(Bool.self, forKey: CodingKeys.hasPrecipitation)
        self.precipitationType = try? valueContainer.decode(String.self, forKey: CodingKeys.precipitationType)
        
    }
}
struct CurrentTemperature: Codable {
    let metric: Metric

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }

        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.metric = try valueContainer.decode(Metric.self, forKey: CodingKeys.metric)
        }

}
struct Metric: Codable {
    let value: Double

    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }

        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
        }

}
struct CurrentConditionWind: Codable {
    let direction: Direction
    let speed: Speed
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.direction = try valueContainer.decode(Direction.self, forKey: CodingKeys.direction)
        self.speed = try valueContainer.decode(Speed.self, forKey: CodingKeys.speed)
    }

}
struct Speed: Codable {
    let metric: SpeedValue
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.metric = try valueContainer.decode(SpeedValue.self, forKey: CodingKeys.metric)
    }
    
}
struct SpeedValue: Codable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try valueContainer.decode(Double.self, forKey: CodingKeys.value)
    }
}

struct Direction: Codable {
    let localized: String
    
    enum CodingKeys: String, CodingKey {
        case localized = "Localized"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.localized = try valueContainer.decode(String.self, forKey: CodingKeys.localized)
    }
}




extension CurrentConditionReturnObjects {
    static func fetchCurrentConditions(cityCode: String, completion: @escaping(CurrentConditionModel) -> Void) {
        print("FetchingCurrentConditions")
        let url = URL(string: "http://dataservice.accuweather.com/currentconditions/v1/" + cityCode + "?apikey=G2egayihsSz2c5sAyKJkQqC9YDABCIUj&language=uk-UA&details=true")!
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let currentConditions = try? jsonDecoder.decode([CurrentConditionReturnObjects].self, from: data) {
                let currentCondition = currentConditions[0]
                let icon = String(currentCondition.icon)
                let date = currentCondition.date.getDayString()
                let temperature = String(Int(currentCondition.temperature.metric.value))
                let humidity = String(currentCondition.humidity)
                let dayOrnight = currentCondition.dayOrNight
                let windSpeed = String(currentCondition.wind.speed.metric.value)
                let windDirection = currentCondition.wind.direction.localized
                let title = currentCondition.text
                let hasPrecipitation = currentCondition.hasPrecipitation
                let precipitationType = currentCondition.precipitationType
                let currentConditionModel = CurrentConditionModel(date: date, temperature: temperature, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, currentConditionTitle: title, icon: icon, hasPrecipitation: hasPrecipitation, precipitationType: precipitationType)
                completion(currentConditionModel)
            }
            else {
                print("Error")
            }
            
        }
        task.resume()
    }
}
