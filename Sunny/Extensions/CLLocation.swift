//
//  CLLocation.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 08.11.2022.
//

import UIKit
import MapKit

// MARK: - CLLocation
extension CLLocation {
    
    // Sometimes city doesn't found. This method find area
    func getCityAndCountry(address: String = "", completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {
            
            // Address - name
            let addressComponents = address.components(separatedBy: ",")
            let shortAddress = addressComponents.first?.trimmingCharacters(in: .whitespaces) ?? address
            
            // Address - coordinates
            let addressCoordinatesComponents = address.components(separatedBy: ";")
            let shortAddressCoordinated = addressCoordinatesComponents.first?.trimmingCharacters(in: .whitespaces) ?? "0.0"
            
            let locality = $0?.first?.locality
            let administrativeArea = $0?.first?.administrativeArea ?? ""
            
            if (Double(shortAddressCoordinated) == nil) {
                completion(shortAddress.contains(administrativeArea) ? administrativeArea : locality, $0?.first?.isoCountryCode, $1)
            } else {
                completion(nil, $0?.first?.isoCountryCode, $1)
            }
        }
    }
    
    func getCoordinates(address: String = "", completion: @escaping (_ latitude: Double, _ longitude: Double) -> ()) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location else { return }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            completion(latitude, longitude)
        }
    }
}
