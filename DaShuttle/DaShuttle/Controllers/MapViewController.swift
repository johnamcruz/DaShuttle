//
//  MapViewController.swift
//  DaShuttle
//
//  Created by John M Cruz on 11/17/18.
//  Copyright © 2018 John M Cruz. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locations = [LocationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let item = childSnapshot.value as! [String: AnyObject]
                    let location = LocationModel(lat: item["lat"] as! Double, lng: item["lng"] as! Double, timestamp: item["lastTimestamp"] as! TimeInterval)
                    self.locations.append(location)
                }
            }
            self.setupMap()
        })
    }
    
    func setupMap() {
        let latitudes = locations.map { location -> Double in
            let location = location as LocationModel
            return location.lat
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as LocationModel
            return location.lng
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotations(getAnnotations())
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        return self.locations.map { location -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = location.lat
            annotation.coordinate.longitude = location.lng
            return annotation
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
