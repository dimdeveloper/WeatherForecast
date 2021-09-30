//
//  Helpers.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 03.09.2021.
//

import Foundation

extension String {
    public func getDateString() -> String {
            // input DateString Example from JSON responce: "2021-09-01T08:00:00+03:00"
        let jSONDateFormatter = DateFormatter()
        jSONDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jSONDateFormatter.calendar = Calendar(identifier: .iso8601)
        jSONDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            // first convert to Date
        let date: Date = jSONDateFormatter.date(from: self)!
        let aPPDateFormatter = DateFormatter()
        aPPDateFormatter.dateFormat = "MMM dd, yyyy"
        aPPDateFormatter.locale = Locale(identifier: "uk_UA")
            // then convert to my format String
        return aPPDateFormatter.string(from: date)
    }
    public func getTimeString() -> String {
        // input DateString Example from JSON responce: "2021-09-01T08:00:00+03:00"
    let jSONDateFormatter = DateFormatter()
    jSONDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    jSONDateFormatter.calendar = Calendar(identifier: .iso8601)
    //jSONDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    jSONDateFormatter.locale = Locale(identifier: "uk_UA")
        // first convert to Date
        guard let date: Date = jSONDateFormatter.date(from: self) else {return "немає даних"}
    
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        //let minute = calendar.component(.minute, from: date)
    
        // then convert to my format String
    return "\(hour):00"
    }
    public func getDayString() -> String {
        // input DateString Example from JSON responce: "2021-09-01T08:00:00+03:00"
    let jSONDateFormatter = DateFormatter()
    jSONDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    jSONDateFormatter.calendar = Calendar(identifier: .iso8601)
    //jSONDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
        // first convert to Date
        let date: Date = jSONDateFormatter.date(from: self)!
        let aPPDateFormatter = DateFormatter()
        aPPDateFormatter.locale = Locale(identifier: "uk_UA")
        aPPDateFormatter.dateFormat = "dd MMMM"
    
        // then convert to my format String
    return aPPDateFormatter.string(from: date)
    }
}
