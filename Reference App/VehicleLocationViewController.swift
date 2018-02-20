//
//  VehicleLocationViewController.swift
//  The App
//
//  Created by Mikk Rätsep on 25/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Car
import MapKit
import UIKit


class VehicleLocationViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!

    private var coordinate: CLLocationCoordinate2D!


    // MARK: IBActions

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getLocation()
    }


    // MARK: Methods

    func updateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate

        updateLocation(coordinate)
    }


    // MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if coordinate == nil {
            getLocation()
        }
        else {
            updateLocation(coordinate)
        }
    }
}

extension VehicleLocationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }

        let annotationView = MKMarkerAnnotationView(annotation: pointAnnotation, reuseIdentifier: "vehicleLocationAnnotation")

        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate else {
            return
        }

        let message = String(format: "Latitude: %.5lf\nLongitude: %.5lf", coordinate.latitude, coordinate.longitude)
        let alertVC = UIAlertController(title: "Vehicle Location", message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let direction = UIAlertAction(title: "Directions", style: .default) { _ in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDefault]

            mapItem.name = "Vehicle Location"
            mapItem.openInMaps(launchOptions: options)
        }

        alertVC.addAction(cancel)
        alertVC.addAction(direction)

        present(alertVC, animated: true, completion: nil)
    }
}

private extension VehicleLocationViewController {

    func bailAndFlail(errorText: String?) {
        OperationQueue.main.addOperation {
            if let text = errorText {
                self.displayStatusBarInfo(text) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func getLocation() {
        Car.shared.getVehicleLocation {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) getVehicleLocation, error: \(error)")

                self.bailAndFlail(errorText: "Failed to get Vehicle Location")
            }
        }
    }

    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        guard isViewLoaded else {
            return
        }

        if let annotation = mapView.annotations.flatMap({ $0 as? MKPointAnnotation }).first {
            UIView.animate(withDuration: 0.5) {
                annotation.coordinate = coordinate

                self.mapView.showAnnotations([annotation], animated: true)
            }
        }
        else {
            let annotation = MKPointAnnotation()

            annotation.coordinate = coordinate
            annotation.title = "Vehicle Location"

            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: false)
        }
    }
}
