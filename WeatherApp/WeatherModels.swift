//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import Foundation

// Models are completed to use full range of data,
// but a few of provided data will be used.

struct WeatherDescription: Codable {
    let icon: String
    let code: Int
    let description: String
}

struct WeatherData: Codable, Equatable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.datetime == rhs.datetime
    }
    
    let moonrise_ts: Int
    let sunset_ts: Int
    let wind_cdir: String
    let rh: Int
    let pres: Double
    let high_temp: Double
    let ozone: Double
    let moon_phase: Double
    let wind_gust_spd: Double
    let snow_depth: Int
    let clouds: Int
    let ts: Int
    let sunrise_ts: Int
    let app_min_temp: Double
    let wind_spd: Double
    let pop: Double
    let wind_cdir_full: String
    let moon_phase_lunation: Double
    let slp: Double
    let app_max_temp: Double
    let valid_date: String
    let vis: Double
    let snow: Double
    let dewpt: Double
    let uv: Double
    let weather: WeatherDescription
    let wind_dir: Int
    let max_dhi: Double?
    let clouds_hi: Int
    let precip: Double
    let low_temp: Double
    let max_temp: Double
    let moonset_ts: Int
    let datetime: String
    let temp: Double
    let min_temp: Double
    let clouds_mid: Int
    let clouds_low: Int
}

struct Weather: Codable {
    let data: [WeatherData]
    let city_name: String
    let country_code: String
    let state_code: String
    let lat: Double
    let lon: Double
    let timezone: String
}
