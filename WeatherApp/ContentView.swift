//
//  ContentView.swift
//  WeatherApp
//
//  Created by Majid on 13/09/2022.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

enum DataError: String, Error {
    case responseFailure = "Unable to retrieve data."
    case decodeFailure = "Error while loading data."
}

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var mapCoordinate: MKCoordinateRegion = .init()
    @State private var weatherData: Weather? = nil
    
    @State private var showError: Bool = false
    @State private var responseError: DataError? = nil
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapCoordinate, showsUserLocation: true)
                .ignoresSafeArea()
            if weatherData != nil {
                WeatherView(data: weatherData!)
            } else {
                // show loading
                ProgressView {
                    Text("Loading weather data...")
                }
                .padding()
                .background(Color("Background").cornerRadius(12))
            }
        }
        // data error alert
        .alert(isPresented: $showError) {
            Alert(title: Text(responseError?.rawValue ?? "Data Error"), dismissButton: .default(Text("Retry"), action: {
                if let location = locationManager.currentLocation {
                    weatherData = nil
                    getWeatherData(using: location)
                }
            }))
        }
        // location error alert
        .alert(isPresented: $locationManager.showLocationError) {
            Alert(title: Text(locationManager.locationError?.rawValue ?? "Location Error"), dismissButton: .default(Text("Retry"), action: {
                if let location = locationManager.currentLocation {
                    getWeatherData(using: location)
                }
            }))
        }
        .onChange(of: locationManager.currentLocation) { newValue in
            guard let newLocation = newValue else { return }
            withAnimation {
                DispatchQueue.main.async {
                    let point = CLLocationCoordinate2D(latitude: CLLocationDegrees(newLocation.coordinate.latitude), longitude: newLocation.coordinate.longitude)
                    mapCoordinate = .init(center: point, span: .init(latitudeDelta: CLLocationDegrees(0.02), longitudeDelta: CLLocationDegrees(0.02)))
                }
            }
            getWeatherData(using: newLocation)
        }
    }
}

extension ContentView {
    func getWeatherData(using location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        var urlComponents = URLComponents(string: "https://api.weatherbit.io/v2.0/forecast/daily")
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "key", value: "a9ff03b3cd404cf98d3c94dfc571e6c0")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    responseError = .responseFailure
                    showError.toggle()
                }
            }
            guard let data = data else { return }
            
            if let weatherItem = try? JSONDecoder().decode(Weather.self, from: data) {
                DispatchQueue.main.async {
                    weatherData = weatherItem
                }
            } else {
                DispatchQueue.main.async {
                    responseError = .decodeFailure
                    showError.toggle()
                }
            }
        }.resume()
    }
}

extension ContentView {
    // a class is needed in order to get authorized for user's Location data
    // and use Delegate which needs Self available to work properly.
    class LocationManager: NSObject, ObservableObject,
                           CLLocationManagerDelegate {
        
        enum LocationError: String, Error {
            case stateFailure = "Error while retrieving location status"
            case accessFailure = "Location access denied"
            
            case lastLocationFailure = "Unable to retrieve last location"
            case locationFailure = "System Location Failed"
        }
        
        @Published var currentLocation: CLLocation? = nil
        
        @Published var locationError: LocationError? = nil
        @Published var showLocationError: Bool = false
        
        private let manager = CLLocationManager()
        
        override init() {
            super.init()
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
                
            case .notDetermined:
                manager.requestAlwaysAuthorization()
                break
            case .denied:
                currentLocation = nil
                locationError = .accessFailure
                showLocationError.toggle()
                break
            case .restricted, .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
                break
            @unknown default:
                locationError = .stateFailure
                showLocationError.toggle()
                return
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let lastLocation = locations.last {
                currentLocation = lastLocation
            } else {
                currentLocation = nil
                locationError = .lastLocationFailure
                showLocationError.toggle()
            }
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            currentLocation = nil
            locationError = .locationFailure
            showLocationError.toggle()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
