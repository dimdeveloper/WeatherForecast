//
//  ForecastModel.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation

//let stringURL = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/326175?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&details=true&metric=true"

// Model
struct ForecastForDay {
    let date: String
    let minTemp: String
    let maxTemp: String
    let dayIcon: String
    let nightIcon: String
    let dayPrecipitationProbability: String
    let nightPrecipitationProbability: String
    let sunRise: String
    let sunSet: String
    let moonRise: String
    let moonSet: String
    let dayDescription: String
    let nightDescription: String
    let dayWindSpeed: String
    let dayWindDirection: String
    let nightWindSpeed: String
    let nightWindDirection: String
    let hoursOfSun: String
    
    
    init(date: String, minTemp: Int, maxTemp: Int, dayIcon: Int32, nightIcon: Int32, dayPrecipitationProbability: Int32, nightPrecipitationProbability: Int32, sunRise: String?, sunSet: String?, moonRise: String?, moonSet: String?, dayDescription: String, nightDescription: String, dayWindSpeed: Double, dayWindDirection: String, nightWindSpeed: Double, nightWindDirection: String, hoursOfSun: Float){
        self.date = date
        self.minTemp = String(minTemp)
        self.maxTemp = String(maxTemp)
        self.dayIcon = String(dayIcon)
        self.nightIcon = String(nightIcon)
        self.dayPrecipitationProbability = String(dayPrecipitationProbability)
        self.nightPrecipitationProbability = String(nightPrecipitationProbability)
        if let sunRise = sunRise {
            self.sunRise = sunRise.getTimeString()
        } else {
            self.sunRise = "немає даних"
        }
        if let sunSet = sunSet {
            self.sunSet = sunSet.getTimeString()
        } else {
            self.sunSet = "немає даних"
        }
        if let moonRise = moonRise {
            self.moonRise = moonRise.getTimeString()
        } else {
            self.moonRise = "немає даних"
        }
        if let moonSet = moonSet {
            self.moonSet = moonSet.getTimeString()
        } else {
            self.moonSet = "немає даних"
        }
        self.dayDescription = dayDescription
        self.nightDescription = nightDescription
        self.dayWindSpeed = String(dayWindSpeed)
        self.dayWindDirection = dayWindDirection
        self.nightWindSpeed = String(nightWindSpeed)
        self.nightWindDirection = nightWindDirection
        self.hoursOfSun = String(hoursOfSun)
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
    let temperature: Temperature
    let day: Day
    let night: Night
    let hoursOfSun: Float
    let sun: Sun
    let moon: Moon
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
        case hoursOfSun = "HoursOfSun"
        case sun = "Sun"
        case moon = "Moon"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
        self.temperature = try valueContainer.decode(Temperature.self, forKey: CodingKeys.temperature)
        self.day = try valueContainer.decode(Day.self, forKey: CodingKeys.day)
        self.night = try valueContainer.decode(Night.self, forKey: CodingKeys.night)
        self.hoursOfSun = try valueContainer.decode(Float.self, forKey: CodingKeys.hoursOfSun)
        self.sun = try valueContainer.decode(Sun.self, forKey: CodingKeys.sun)
        self.moon = try valueContainer.decode(Moon.self, forKey: CodingKeys.moon)
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
    let icon: Int32
    let iconPhrase: String
    let precipitationProbability: Int32
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case precipitationProbability = "PrecipitationProbability"
        case wind = "Wind"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.icon = try valueContainer.decode(Int32.self, forKey: CodingKeys.icon)
        self.iconPhrase = try valueContainer.decode(String.self, forKey: CodingKeys.iconPhrase)
        self.precipitationProbability = try valueContainer.decode(Int32.self, forKey: CodingKeys.precipitationProbability)
        self.wind = try valueContainer.decode(Wind.self, forKey: CodingKeys.wind)
        
    }
}
struct Night: Codable {
    let icon: Int32
    let iconPhrase: String
    let precipitationProbability: Int32
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case precipitationProbability = "PrecipitationProbability"
        case wind = "Wind"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.icon = try valueContainer.decode(Int32.self, forKey: CodingKeys.icon)
        self.iconPhrase = try valueContainer.decode(String.self, forKey: CodingKeys.iconPhrase)
        self.precipitationProbability = try valueContainer.decode(Int32.self, forKey: CodingKeys.precipitationProbability)
        self.wind = try valueContainer.decode(Wind.self, forKey: CodingKeys.wind)
        
    }
}
struct Sun: Codable {
    let rise: String?
    let set: String?
    
    enum CodingKeys: String, CodingKey {
        case rise = "Rise"
        case set = "Set"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.rise = try? valueContainer.decode(String.self, forKey: CodingKeys.rise)
        self.set = try? valueContainer.decode(String.self, forKey: CodingKeys.set)
    }
}
struct Moon: Codable {
    let rise: String?
    let set: String?
    
    enum CodingKeys: String, CodingKey {
        case rise = "Rise"
        case set = "Set"
    }
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.rise = try? valueContainer.decode(String.self, forKey: CodingKeys.rise)
        self.set = try? valueContainer.decode(String.self, forKey: CodingKeys.set)
    }
}
struct Wind: Codable {
    let direction: Direction
    let speed: SpeedValue
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.direction = try valueContainer.decode(Direction.self, forKey: CodingKeys.direction)
        self.speed = try valueContainer.decode(SpeedValue.self, forKey: CodingKeys.speed)
    }

}

extension ForecastModel {
    static func fetchForecast(locationID: String, completion: @escaping([ForecastForDay]) -> Void){
        let stringURL = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/" + locationID + "?apikey=6RSXlYdaEhRIG7iMuwgmDccQNI3ELQ3Y&language=uk-UA&details=true&metric=true"
        let basicURL = URL(string: stringURL)!
        print(basicURL)
        let task = URLSession.shared.dataTask(with: basicURL) { (data, responce, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let forecast = try? jsonDecoder.decode(ForecastModel.self, from: data) {
                let forecasts = forecast.dailyForecasts
                var forecastForDay: [ForecastForDay] = []
                for dayForecast in forecasts {
                    let date = dayForecast.date.getDayString()
                    let minTemp = Int(dayForecast.temperature.minimum.value)
                    let maxTemp = Int(dayForecast.temperature.maximum.value)
                    let dayIcon = dayForecast.day.icon
                    let nightIcon = dayForecast.night.icon
                    let dayPrecipitationProbability = dayForecast.day.precipitationProbability
                    let nightPrecipitationProbability = dayForecast.night.precipitationProbability
                    let sunRise = dayForecast.sun.rise
                    let sunSet = dayForecast.sun.set
                    let moonRise = dayForecast.moon.rise
                    let moonSet = dayForecast.moon.set
                    let dayDescription = dayForecast.day.iconPhrase
                    let nightDescription = dayForecast.night.iconPhrase
                    let dayWindSpeed = dayForecast.day.wind.speed.value
                    let dayWindDirection = dayForecast.day.wind.direction.localized
                    let nightWindSpeed = dayForecast.night.wind.speed.value
                    let nightWindDirection = dayForecast.night.wind.direction.localized
                    let hoursOfSun = dayForecast.hoursOfSun
                    forecastForDay.append(ForecastForDay(date: date, minTemp: minTemp, maxTemp: maxTemp, dayIcon: dayIcon, nightIcon: nightIcon, dayPrecipitationProbability: dayPrecipitationProbability, nightPrecipitationProbability: nightPrecipitationProbability, sunRise: sunRise, sunSet: sunSet, moonRise: moonRise, moonSet: moonSet, dayDescription: dayDescription, nightDescription: nightDescription, dayWindSpeed: dayWindSpeed, dayWindDirection: dayWindDirection, nightWindSpeed: nightWindSpeed, nightWindDirection: nightWindDirection, hoursOfSun: hoursOfSun))

                }
             completion(forecastForDay)
            } else {
                print("Error retreiving data")
            }
        }
        task.resume()
    }
    

}
