//
//  ViewController.swift
//  Sirkit
//
//  Created by Shivadharshan Lingeswaran on 07/07/2018.
//  Copyright © 2018 AssGuard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class ViewController: UIViewController, MKMapViewDelegate{
    
    
    
    class customPin: NSObject, MKAnnotation{
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(pinTitle:String,pinSubTitle:String,location:CLLocationCoordinate2D) {
            self.title=pinTitle
            self.subtitle=pinSubTitle
            self.coordinate=location
        }
    }
    
    
    
    
   
    @IBOutlet weak var mapView: MKMapView!
    
    //var pin:AnnotationPin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 51.507351 , longitude: -0.127758 )
        let destinationLocation = CLLocationCoordinate2D(latitude: 52.486243, longitude: -1.890401 )
        let thirdLocation = CLLocationCoordinate2D(latitude: 53.480759 , longitude: -2.242631)
        
        let sourcePin = customPin(pinTitle: "London", pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: "Birmingham", pinSubTitle: "", location: destinationLocation)
        
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("We have an error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = directionResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        self.mapView.delegate = self
    }
    
    
    
    
    
    //MARK:- MapKitdlegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor=UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
    
    
    
    //mapView.delegate = self
    
    //let coordinate = CLLocationCoordinate2D(latitude: 51.559106, longitude: 0.13001277)
    //let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
    //mapView.setRegion(region, animated: true)
    
    //pin = AnnotationPin(title: "Red Light", subtitle:"Test" , coordinate: coordinate)
    //mapView.addAnnotation(pin)
}

//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//  let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "redlight")
//annotationView.image = UIImage(named: "cctv.png")
//let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//annotationView.transform = transform
//return annotationView


//func didReceiveMemoryWarning() {
//      super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
