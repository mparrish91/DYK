//
//  CLLocationCoordinate2d-ext.swift
//
//  Created by Navarjun on 14/08/15.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func distanceFromCoordinateInKM(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        // in Kilometers
        let selectedLocation = CLLocation(latitude: latitude, longitude: longitude)
        let driverLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = selectedLocation.distanceFromLocation(driverLocation)
        
        return distance/1000
    }
    
    func distanceFromCoordinateInMiles(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        // in Miles
        let selectedLocation = CLLocation(latitude: latitude, longitude: longitude)
        let driverLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = selectedLocation.distanceFromLocation(driverLocation)
        
        return distance/1609.3
    }
    
    func distanceFromCoordinateInMeters(coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        // in meters
        let selectedLocation = CLLocation(latitude: latitude, longitude: longitude)
        let driverLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = selectedLocation.distanceFromLocation(driverLocation)
        
        return distance
    }
}