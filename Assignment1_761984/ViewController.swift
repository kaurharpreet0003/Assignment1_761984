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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var segment_Control: UISegmentedControl!
    @IBOutlet weak var findMyWayBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKPointAnnotation?
     
     var userLati: CLLocationDegrees = 0.0
     var userLong: CLLocationDegrees = 0.0
     var Lati: CLLocationDegrees = 0.0
     var long: CLLocationDegrees = 0.0
     var userCoordinate: CLLocationCoordinate2D?

    // var newCoordinate: CLLocationCoordinate2D?
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
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)
        mapView.showsUserLocation = true
        
    }
    
    @objc func dtgr(gestureReco: UITapGestureRecognizer) {
        if tapVar == 0 {
            
            
            let tap = gestureReco.location(in: mapView)
            let coordinate = mapView.convert(tap, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            

           
            Lati = annotation.coordinate.latitude
            long = annotation.coordinate.longitude
            route(destinationCCordinator: annotation.coordinate)

            
            tapVar = 1
        
            
        }
        
        //43.6532° N, 79.3832°
    }
    
    func route(destinationCCordinator: CLLocationCoordinate2D) {
        mapView.delegate = self
        
        let userLocation = CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38)
        let destination = CLLocationCoordinate2D(latitude: destinationCCordinator.latitude, longitude: destinationCCordinator.longitude)
        let Placemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        let destination_Placemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: Placemark)
        let destinationMI = MKMapItem(placemark: destination_Placemark)
        let source_annotation = MKPointAnnotation()
        
        if let location = Placemark.location {
             source_annotation.coordinate = location.coordinate
        }
        
         let destination_anno = MKPointAnnotation()
        if let location = destination_Placemark.location {
        destination_anno.coordinate = location.coordinate
         self.mapView.showAnnotations([source_annotation,destination_anno], animated: true )
            
        }
        
        let direction_req = MKDirections.Request()
                       direction_req.source = mapItem
                       direction_req.destination = destinationMI
                       //direction_req.transportType = .automobile
                    switch segment_Control.selectedSegmentIndex {
                      case 0:
                          direction_req.transportType = .automobile
                      case 1:
                          direction_req.transportType = .walking
                      default:
                          direction_req.transportType = .walking
                      }
          let map_directions = MKDirections(request: direction_req)
         map_directions.calculate {
            (response, error) -> Void in
        guard let Response = response else {
                if let error = error {
                        print("Error: \(error)")
                }
                return
            }
            let routes = Response.routes[0]
            self.mapView.addOverlay((routes.polyline), level: MKOverlayLevel.aboveRoads)
            //self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let map_rect = routes.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(map_rect), animated: true)
            
        }

    
    }
    @IBAction func findWayButton(_ sender: UIButton) {
        //getroute(destination: destination)
        //route(destinationCCordinator: annotation!.coordinate)
        route(destinationCCordinator: annotation!.coordinate)
       
        }
}


    extension ViewController : MKMapViewDelegate
    {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation{
                    return nil
            }else{
                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
                pin.animatesDrop = true
                pin.tintColor = .red
                return pin
            }
        }
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if overlay is MKPolyline{
                    let rendrer = MKPolylineRenderer(overlay: overlay)
                    rendrer.strokeColor = UIColor.orange
                    rendrer.lineWidth = 4.0
                    return rendrer

                }
                return MKOverlayRenderer()

            }

}



  
