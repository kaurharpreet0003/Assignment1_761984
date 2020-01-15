//
//  ViewController.swift
//  Assignment1_761984
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var findMyWayBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    //var Pin = MKPinAnnotationView()
    //let regionBymeters: Double = 5000
    
    
    var tapVar = 0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dtgr))
        mapView.addGestureRecognizer(doubleTap)
        
        //let region = MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, latitudinalMeters: regionBymeters, longitudinalMeters: regionBymeters)
        
    }
    
    @objc func dtgr(gestureReco: UITapGestureRecognizer) {
        if tapVar == 0 {
            
            
            let tap = gestureReco.location(in: mapView)
            let coordinate = mapView.convert(tap, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            tapVar += 1
            
            
        }
        
        //43.6532° N, 79.3832°

    

            }
    func getUserDirection(destination: CLLocationCoordinate2D)  {
        let req = MKDirections.Request()
        let coordinate = mapView.userLocation.coordinate
        let source = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
        let placemark = MKPlacemark(coordinate: source)
        let destiPlaceMark = MKPlacemark(coordinate: destination)
        
        
        
        
    }
    
}
   
    




