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
        
        var array : [String]?
        var holder : [Any] = []
        var elements : [Any] = []
        var lat : [Any] = []
        var long : [Any] = []
        var speed : [Any] = []
        var type : [Any] = []
        
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "cameraData1", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.macOSRoman)
                array = data.components(separatedBy: "\n")
                for line in array!{
                    let baseData = line.components(separatedBy: "\t")
                    for line in baseData{
                        let latExtract = line.components(separatedBy: "\r" )
                        for line in latExtract{
                            _ = holder.append(line.components(separatedBy: ","))
                            
                        }
                        
                        }
                    }
                }
                
            //print(holder)
            //print(holder.count)
        } catch let err as NSError {
            // do something with Error
            print(err)
        }//parsed data into holder
    
        for i in 0..<holder.count {
            if i % 4 == 0 {
                lat.append(holder[i])
            }
            if ((i+1) % 4) == 0 {
                type.append(holder[i])
            }
            if (i % 4) == 1 {
                long.append(holder[i])
            }
            if (i % 4) == 2 {
                speed.append(holder[i])
            }
        }
            
        print(lat)
        print(long)
        print(speed)
        print(type)
        
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
