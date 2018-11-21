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

        // location added eventß
        let ref = Database.database().reference()
        ref.observe(.childAdded, with: { snapshot in
            self.locations.append(LocationModel(snapshot: snapshot))
            self.setupMap()
        })
        
        // location change event
        ref.observe(.childChanged, with: { snapshot in
            let location = LocationModel(snapshot: snapshot)
            if let annotation = self.mapView.annotations.first(where: {  $0.title == location.tag }) {
                self.mapView.removeAnnotation(annotation)
                self.mapView.addAnnotation(self.createAnnotation(location: location))
                self.locations.removeAll(where:{ $0.id == location.id })
                self.locations.append(location)
                self.updateRegion()
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: Constants.mapReuseIdentifier)
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.mapReuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: Constants.trolleyImage)
        annotationView?.animate()
        return annotationView
    }

    func setupMap() {
        self.updateRegion()
        self.mapView.addAnnotations(getAnnotations())
    }
    
    func updateRegion() {
        let latitudes = locations.map { $0.lat }
        
        let longitudes = locations.map { $0.lng }
        
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
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        return self.locations.map { createAnnotation(location: $0) }
    }
    
    func createAnnotation(location: LocationModel) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.tag
        annotation.coordinate.latitude = location.lat
        annotation.coordinate.longitude = location.lng
        return annotation
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
