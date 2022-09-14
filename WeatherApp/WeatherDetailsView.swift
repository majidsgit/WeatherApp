//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import SwiftUI

struct WeatherUVView: View {
    
    let uv: Double
    
    private func getStatus() -> String {
        switch uv {
        case 0...2:
            return "Low"
        case 3...5:
            return "Medium"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11...:
            return "Extremely High"
        default:
            return "Unknown"
        }
    }
    
    private func getX(geoWidth: Double, itemWidth: Double) -> Double {
        let value = uv / 11 * geoWidth
        if value >= geoWidth {
            return geoWidth - itemWidth
        } else if value < 0 {
            return 0
        } else {
            return value - (itemWidth / 2)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            
            HStack {
                
                Text("UV Indicator")
                    .font(.headline.weight(.black))
                    .foregroundColor(.primary)

                Spacer()
                
                Text(getStatus())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
            }
            
            ZStack(alignment: .leading) {
                
                GeometryReader { geo in
                    LinearGradient(stops: [
                        .init(color: .green, location: 0),
                        .init(color: .yellow, location: 3/11),
                        .init(color: .orange, location: 5/11),
                        .init(color: .red, location: 8/11),
                        .init(color: .purple, location: 10/11),
                    ], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 10)
                    .cornerRadius(5)
                    
                    Circle()
                        .frame(width: 14)
                        .foregroundColor(.black)
                        .offset(x: getX(geoWidth: geo.size.width, itemWidth: 14))
                        .offset(y: -2)
                    
                    Text("\(uv, specifier: "%.1f")")
                        .font(.subheadline.weight(uv > 8 ? .black : (uv > 3 ? .bold : .regular ) ))
                        .foregroundColor(.primary)
                        .offset(x: getX(geoWidth: geo.size.width, itemWidth: 33))
                        .offset(y: -22)
                        .multilineTextAlignment( getX(geoWidth: geo.size.width, itemWidth: 0) >= geo.size.width ? .trailing : .leading)
                    
                }
            }
                .frame(height: 14)
        }
        .padding()
        .background(Color("Background").cornerRadius(12))
    }
}

struct WeatherSunAndMoonDegreeView: View {
    let heading: String
    
    let title1: String
    let icon1: String
    let rise: Int
    
    let title2: String
    let icon2: String
    let set: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(heading)
                .font(.headline.weight(.black))
                .foregroundColor(.primary)
            HStack {
                
                Image(systemName: icon1)
                    .font(.system(size: 32))
                    .foregroundColor(.primary)
                VStack(alignment: .leading) {
                    Text(title1)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text(rise.toStringClockDate())
                        .font(.headline.weight(.black))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(title2)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text(set.toStringClockDate())
                        .font(.subheadline.weight(.black))
                        .foregroundColor(.primary)
                }
                Image(systemName: icon2)
                    .font(.system(size: 32))
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color("Background").cornerRadius(12))
    }
}

struct WeatherDetailsView: View {
    
    let data: WeatherData
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 24.0) {
                VStack {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: -4) {
                            Text(data.ts.toStringDate())
                                .font(.largeTitle)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 8) {
                        Image(data.weather.icon)
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("\(data.temp, specifier: "%.1f")°C")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text(data.weather.description)
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                    }
                    
                }
                .padding()
                .background(Color("Background").cornerRadius(12))
                
                WeatherMaxMinDegreeView(max: data.max_temp, min: data.min_temp)

                WeatherUVView(uv: data.uv)
                WeatherUVView(uv: 0)
                WeatherUVView(uv: 11)
                WeatherUVView(uv: 18)
                
                WeatherSunAndMoonDegreeView(heading: "Sun Time", title1: "Rise", icon1: "sunrise.fill", rise: data.sunrise_ts, title2: "Set", icon2: "sunset", set: data.sunset_ts)
                
                WeatherSunAndMoonDegreeView(heading: "Moon Time", title1: "Rise", icon1: "moon.fill", rise: data.moonrise_ts, title2: "Set", icon2: "moon", set: data.moonset_ts)
                
            }
        }
        .padding()
    }
}
