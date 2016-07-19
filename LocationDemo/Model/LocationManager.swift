//
//  LocationManager.swift
//  LocationDemo
//
//  Created by TamLTM on 7/15/16.
//  Copyright © 2016 Asiantech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject {
    var longitude: Double?
    var latitude: Double?
    var location = CLLocationManager()
    static var sharedInstance = LocationManager()
    
    override init() { //Singleton
        super.init()
        self.location.delegate = self
        self.location.desiredAccuracy = kCLLocationAccuracyBest
        self.location.requestWhenInUseAuthorization()
        self.location.startUpdatingLocation()
        
        //--- Find Address of Current Location ---//
        let location = self.location.location
        self.latitude = location!.coordinate.latitude
        self.longitude = location!.coordinate.longitude
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //    self.location.stopUpdatingLocation()
        //--- CLGeocode to get address of current location ---//
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
    
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            location.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let streetName = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            print("DiaBan: \(locality!)")
            print("Ma BD: \(postalCode!)")
            print("Dia Chi: \(administrativeArea!)")
            print("Vung: \(country!)")
            print("Street: \(streetName!)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ERROR" + error.localizedDescription)
    }
}
