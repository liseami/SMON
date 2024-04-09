//
//  LocationManager.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    
    @Published var locationError: Error?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func uploadUserLocation() {
        locationManager.requestLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var gotLocation: () async -> () = {}
    func startUpdatingLocation(whenGot: @escaping () async -> ()) {
        gotLocation = whenGot
        print("开始获取用户定位")
        locationManager.stopUpdatingLocation()
        locationManager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            print("获取到最新的定位")
            Task {
                UserManager.shared.userlocation = .init(lat: location.latitude.string, long: location.longitude.string)
                await UserManager.shared.getVersionInfo()
                await gotLocation()
                self.locationManager.stopUpdatingLocation() // 停止位置更新
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("获取定位错误")
        DispatchQueue.main.async {
            Apphelper.shared.pushNotification(type: .error(message: "获取定位错误。"))
        }
        locationError = error
    }
}
