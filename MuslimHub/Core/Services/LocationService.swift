import Foundation
import CoreLocation

@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()

    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var heading: CLHeading?
    var locationError: String?

    /// Called when location is updated; use this to refetch prayer times etc. without pull-to-refresh.
    var onLocationUpdate: (() -> Void)?

    private let locationManager = CLLocationManager()

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }

    // MARK: - Public Methods
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func startUpdatingHeading() {
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        }
    }

    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
    }

    // MARK: - Qibla Calculation
    /// Bearing from the user's location to the Kaaba in Makkah (degrees from true north, 0–360).
    /// Varies by location on Earth (e.g. ~291°–295° in some regions); computed from GPS coordinates.
    var qiblaDirection: Double {
        guard let location = currentLocation else { return 0 }

        let makkahLat = 21.4225 * .pi / 180   // Kaaba, Makkah
        let makkahLon = 39.8262 * .pi / 180
        let userLat = location.coordinate.latitude * .pi / 180
        let userLon = location.coordinate.longitude * .pi / 180

        let deltaLon = makkahLon - userLon

        let y = sin(deltaLon) * cos(makkahLat)
        let x = cos(userLat) * sin(makkahLat) - sin(userLat) * cos(makkahLat) * cos(deltaLon)

        var qibla = atan2(y, x) * 180 / .pi
        if qibla < 0 { qibla += 360 }

        return qibla
    }

    var qiblaRelativeToNorth: Double {
        let deviceHeading = heading?.magneticHeading ?? 0
        return qiblaDirection - deviceHeading
    }

    // MARK: - CLLocationManagerDelegate
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            self.currentLocation = locations.last
            self.onLocationUpdate?()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        Task { @MainActor in
            self.heading = newHeading
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedWhenInUse ||
               manager.authorizationStatus == .authorizedAlways {
                self.startUpdatingLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationError = error.localizedDescription
        }
    }
}
