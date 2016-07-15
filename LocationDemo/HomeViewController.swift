//
//  HomeViewController.swift
//  LocationDemo
//
//  Created by TamLTM on 7/15/16.
//  Copyright © 2016 Asiantech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak private var map: MKMapView!
    @IBOutlet weak private var latitudeLabel: UILabel!
    @IBOutlet weak private var longitudeLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var streetLabel: UILabel!
     
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureHomeViewController() {
        setUpUI()
        setUpData()
    }
    
    func setUpUI() {
//        // Init the zoom level
//        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)
//        let span = MKCoordinateSpanMake(100, 80)
//        let region = MKCoordinateRegionMake(coordinate, span)
//        self.map.setRegion(region, animated: true)
    }
    
    func setUpData() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        //--- Find Address of Current Location ---//
        let location = self.locationManager.location
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
//        --- CLGeocode to get address of current location ---//
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
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let streetName = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
    
            // Street address
            streetLabel.text = "\(streetName!)" + " \(administrativeArea!)" + " \(country!)"
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
