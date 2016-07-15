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
    var locationManager = CLLocationManager()
    static var sharedInstance = LocationManager()
    override init() { //simgthon
        super.init()
        locationManager.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //--- Find Address of Current Location ---//
        let location = self.locationManager.location
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
    }
}



extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
   //     self.locationManager.stopUpdatingLocation()
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
         //   locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let streetName = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            
            // Street address
        //    streetLabel.text = "\(streetName!)" + " \(administrativeArea!)" + " \(country!)"
            print("DiaBan: \(locality!)")
            print("Ma BD: \(postalCode!)")
            print("AD: \(administrativeArea!)")
            print("Vung: \(country!)")
            print("Street: \(streetName!)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ERROR" + error.localizedDescription)
    }
}
