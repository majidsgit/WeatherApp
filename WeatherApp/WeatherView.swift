//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import Foundation
import SwiftUI

struct WeatherForecastDaysView: View {
    
    let title: String
    let range: Range<Int>
    let items: [WeatherData]
    
    @State private var isPresented: Bool = false
    @State private var detailData: WeatherData? = nil
    
    func getDayView(item: WeatherData) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Image(item.weather.icon)
                .resizable()
                .frame(width: 36, height: 36)
            Text("\(item.temp, specifier: "%.0f")°C")
                .font(.subheadline)
                .foregroundColor(.primary)
            Text(item.valid_date.toStringDate())
                .font(.subheadline.bold())
                .foregroundColor(.primary)
            
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.weight(.black))
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(range) { index in
                        getDayView(item: items[index])
                            .onTapGesture {
                                detailData = items[index]
                                isPresented.toggle()
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $isPresented, content: {
            Text(detailData?.datetime ?? "no data!")
        })
        .padding()
        .background(Color("Background").cornerRadius(12))
    }
}

struct WeatherMaxMinDegreeView: View {
    let max: Double
    let min: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Temperature Change")
                .font(.headline.weight(.black))
                .foregroundColor(.primary)
            HStack {
                
                Image(systemName: "thermometer")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: -1, z: 0))
                VStack(alignment: .leading) {
                    Text("Min")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Text("\(min, specifier: "%.1f")°C")
                        .font(.headline.weight(.black))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Max")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Text("\(max, specifier: "%.1f")°C")
                        .font(.subheadline.weight(.black))
                        .foregroundColor(.red)
                }
                Image(systemName: "thermometer")
                    .font(.system(size: 32))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color("Background").cornerRadius(12))
    }
}

struct WeatherView: View {
    let data: Weather
    
    @State private var today: WeatherData? = nil
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("")
                .padding(.top, 5)
            VStack(alignment: .center, spacing: 24) {
                
                VStack {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: -4) {
                            Text(data.city_name)
                                .font(.largeTitle)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                            Text(today?.ts.toStringDate() ?? "")
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 8) {
                        Image(today?.weather.icon ?? "c01n")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("\(today?.temp ?? 0.0, specifier: "%.1f")°C")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        Text(today?.weather.description ?? "unknown")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                    }
                    
                }
                .padding()
                .background(Color("Background").cornerRadius(12))
                
                WeatherMaxMinDegreeView(max: today?.max_temp ?? 0, min: today?.min_temp ?? 0)
                
                WeatherForecastDaysView(title: "Next 5 Days Forecast", range: 1..<6, items: data.data)
                
                WeatherForecastDaysView(title: "Near Future Forecase", range: 6..<11, items: data.data)
                
                WeatherForecastDaysView(title: "Far Future Forecast", range: 11..<16, items: data.data)
                
            }
            Text("")
                .padding(.vertical, 5)
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear {
            today = data.data[0]
        }
        
    }
}
