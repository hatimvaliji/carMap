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
import Foundation



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
var locationManager = CLLocationManager()
var currentLocation: CLLocation?
var points1: [[CLLocationCoordinate2D]] = []
    

    var array : [String]?
    var holder : [Any] = []
    var lat = [] as [[String]]
    var long = [] as [[String]]
    var speed = [] as [[String]]
    var type = [] as [[String]]

    var reducedLat : [Double] = []
    var reducedLong : [Double] = []
    var reducedType : [Any] = []
    var reducedSpeed : [Any] = []
    
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
        //ready to parse
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }else {
            print("Please turn on location services.")
        }
       
        
        
        do {//parsing
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
        
      
        //further parsing
        for i in 0..<holder.count {
            if i % 4 == 0 {
                lat.append(holder[i] as! [String])
            }
            if ((i+1) % 4) == 0 {
                type.append(holder[i] as! [String])
            }
            if (i % 4) == 1 {
                long.append(holder[i] as! [String])
            }
            if (i % 4) == 2 {
                speed.append(holder[i] as! [String])
            }
        }
        
        
        let reducedLat = lat.joined().compactMap(Float.init) // changing array of arrays of strings into array of doubles
        let reducedLong = long.joined().compactMap(Float.init) //^^
        let reducedType = type.flatMap{$0} // ^
        let reducedSpeed = speed.flatMap{$0} // ^
        //print(reducedLat)
        //print(reducedLong)
        //print(reducedType)
        //print(reducedSpeed)
     
    
        
        
 //       while locationManager.location?.coordinate != nil {
   //         for i in 0..<reducedLat.count{
     //           while locationManager.location?.coordinate.latitude != (Double(reducedLat[i])) || locationManager.location?.coordinate.longitude != (Double(reducedLong[i])){
       //             while locationManager.location?.coordinate != nil {
         //           }
           //     }
//            }
  //      }
            
        
       
            
            
            // droppin pins
        
        //attempt at making radius around all pins and user locatio
//
        

       // let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        //let circleCenter  = CLLocation(latitude: CLLocationDegrees(reducedLat[0]), longitude: CLLocationDegrees(reducedLong[0]))
      
        //for i in 0..<lat.count{

        points1.append(radiusSearchPoints(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(reducedLat[0]), CLLocationDegrees(reducedLong[0])), radius: 10))
        // }//makes an array of coords which lay on the circumference of the original circle
        print(points1)
        
        
        
        
       
        
       
        
        
        for i in 0..<lat.count {
            let locations1 = customPin(pinTitle: reducedType[i]+" "+reducedSpeed[i], pinSubTitle: "", location: CLLocationCoordinate2DMake(CLLocationDegrees(reducedLat[i]), CLLocationDegrees(reducedLong[i])))
            self.mapView.addAnnotation(locations1)
            let rad = CLLocationDistance(10)
            let circles = [MKCircle(center: (CLLocationCoordinate2DMake(CLLocationDegrees(reducedLat[i]), CLLocationDegrees(reducedLong[i]))), radius: rad)]
            self.mapView.addOverlays(circles)
        }
        mapView.delegate = self//absolutely necessry!
        
        
        
    
       
       
        
  
        
               
        
    }//end of viewDidLoad
        
    
    internal func radiusSearchPoints(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> [CLLocationCoordinate2D]
    {
        var points: [CLLocationCoordinate2D] = []
        let earthRadius = 6378100.0
        let π = M_PI
        
        let lat = coordinate.latitude * π / 180.0
        let lng = coordinate.longitude * π / 180.0
        
        for t in stride(from: 0, to: 2 * π, by: 0.3){
            let pointLat = lat + (radius / earthRadius)  * sin(t)
            let pointLng = lng + (radius / earthRadius) * cos(t)
            
            var circPointLat : [Double] = []
            var circPointLong : [Double] = []
            
            circPointLat.append((pointLat * 180 / π))
            circPointLong.append((pointLng * 180 / π))
            
            let point = CLLocationCoordinate2D(latitude: (pointLat * 180 / π), longitude: (pointLng * 180 / π))
            points.append(point)
            
          //  for i in 0..<points.count {
            //    let locations2 = customPin(pinTitle: "CircPoint", pinSubTitle: "", location: points[i])
              //   self.mapView.addAnnotation(locations2)
           // } This bit of code plots pins on the circle that th system will try avoid
            
            
            
        }
        return points
    }//this takes a centre poit and radius to provide a number of points on the circumference of the circle
    
    

    
    
    
    
    //var currentUserLocation =
    
    //MARK:- MapKitdlegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        guard let locations = locationManager.location?.coordinate else{
            return
        }
        print("locations = \(locations.latitude) \(locations.longitude)")
        
        
      //  while locationManager.location?.coordinate != nil {
            //while
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!), span: span)
        self.mapView.setRegion(region, animated: true)
        
        //attempt at routing by avoiding pin coords
        let sourceLoc = (locationManager.location?.coordinate)!
        let destLoc = CLLocationCoordinate2DMake(51.559104919433601, 0.13010259757630524)//    51.5033640  -0.1276250
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLoc)
        let destPlacemark = MKPlacemark(coordinate: destLoc)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            
            guard let response = response else {
                if let error = error {
                    print("Something went wrong.")
                }
                return
            }
            let route  = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })
        
        }
   // }
    
    func locationManagerError(_manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer1 = MKPolylineRenderer(overlay: overlay)
            renderer1.strokeColor = UIColor.blue
            renderer1.lineWidth = 0.5
            return renderer1
        }
        
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.2)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 0.5
            return renderer
}
        
        return MKOverlayRenderer()
        
    }
    
}



//func didReceiveMemoryWarning() {
//      super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
