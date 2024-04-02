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
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationError: Error?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        setupLocationManager()
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
    }
    
    var gotLocation: () -> () = {}
    func startUpdatingLocation(whenGot: @escaping () -> ()) {
        locationManager.startUpdatingLocation()
        gotLocation = whenGot
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            userLocation = location
            UserManager.shared.userlocation = .init(lat: location.latitude.string, long: location.longitude.string)
            Task { await UserManager.shared.getVersionInfo()
                gotLocation()
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        // 用户已拒绝该应用访问位置数据。
        case .denied:
            DispatchQueue.main.async {
                Apphelper.shared.pushNotification(type: .error(message: "已拒绝位置访问。"))
            }
            print("已拒绝访问位置权限。")
        // 用户已授权该应用在使用期间可以访问位置数据。这种权限只允许在应用处于前台时获取位置更新。
        case .authorizedWhenInUse:
            print("已授权用户访问。")
            
        @unknown default:
            print(manager.authorizationStatus.rawValue)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
}
