//
//  NaviDestinationViewController.swift
//  The App
//
//  Created by Mikk Rätsep on 29/01/2018.
//  Copyright © 2018 High-Mobility GmbH. All rights reserved.
//

import Car
import CoreLocation
import MapKit
import UIKit


class NaviDestinationViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!

    private var coordinate: CLLocationCoordinate2D!
    private var name: String!


    // MARK: IBAction

    @IBAction func dropPinGestureRecognised(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }

        let coordinate = mapView.convert(sender.location(in: nil), toCoordinateFrom: nil)
        let annotation = MKPointAnnotation()

        annotation.coordinate = coordinate
        annotation.title = "New Navi Destination"
        annotation.subtitle = "Navi Destination"

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)

        getNewName(coordinate: coordinate)
    }

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getDestination()
    }


    // MARK: Methods

    func updateCoordinate(_ coordinate: CLLocationCoordinate2D, name: String) {
        updateDestination(coordinate, name: name)
    }


    // MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (coordinate == nil) || (name == nil) {
            getDestination()
        }
        else {
            updateDestination(coordinate, name: name)
        }
    }
}

extension NaviDestinationViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }

        let view = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "naviDestinationAnnotation")

        view.animatesDrop = true
        view.isDraggable = true
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate, let name = self.name else {
            return
        }

        let message = String(format: "\(name)\n\nLatitude: %.5lf\nLongitude: %.5lf", coordinate.latitude, coordinate.longitude)
        let alertVC = UIAlertController(title: "Navi Destination", message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)

        let direction = UIAlertAction(title: "Directions", style: .default) { _ in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDefault]

            mapItem.name = "Navi Destination"
            mapItem.openInMaps(launchOptions: options)
        }

        let sendToCar = UIAlertAction(title: "Send to Vehicle", style: .default) { _ in
            Car.shared.sendNaviDestination(coordinate: coordinate, name: name) {
                if let error = $0 {
                    print("\(type(of: self)) -\(#function) sendNaviDestination, error: \(error)")

                    self.bailAndFlail(errorText: "Failed to set Navi Destination")
                }
            }
        }

        alertVC.addAction(cancel)
        alertVC.addAction(direction)
        alertVC.addAction(sendToCar)

        present(alertVC, animated: true, completion: nil)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .ending:
            guard let annotation = mapView.annotations.compactMap({ $0 as? MKPointAnnotation }).first else {
                return
            }

            annotation.title = "New Navi Destination"
            annotation.subtitle = "New Navi Destination"

            coordinate = annotation.coordinate

            getNewName(coordinate: annotation.coordinate)

        default:
            break
        }
    }
}

private extension NaviDestinationViewController {

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

    func getDestination() {
        Car.shared.getNaviDestination {
            if let error = $0 {
                print("\(type(of: self)) -\(#function) getNaviDestionation, error: \(error)")

                self.bailAndFlail(errorText: "Failed to get Navi Destination")
            }
        }
    }

    func getNewName(coordinate: CLLocationCoordinate2D) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }

            var addressPieces: [String] = []

            if let street = placemark.thoroughfare, let number = placemark.subThoroughfare {
                addressPieces.append(street + " " + number)
            }
            else if let name = placemark.name {
                addressPieces.append(name)
            }

            if let city = placemark.locality {
                if let postalCode = placemark.postalCode {
                    addressPieces.append(postalCode + " " + city)
                }
                else {
                    addressPieces.append(city)
                }
            }

            if let country = placemark.country {
                addressPieces.append(country)
            }

            self.name = addressPieces.joined(separator: ", ")

            if let annotation = self.mapView.annotations.compactMap({ $0 as? MKPointAnnotation }).first {
                annotation.title = self.name
            }
        }
    }

    func updateDestination(_ coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.name = name

        guard isViewLoaded else {
            return
        }

        if let annotation = mapView.annotations.compactMap({ $0 as? MKPointAnnotation }).first {
            UIView.animate(withDuration: 0.5) {
                annotation.coordinate = coordinate
                annotation.title = name

                self.mapView.showAnnotations([annotation], animated: true)
            }
        }
        else {
            let annotation = MKPointAnnotation()

            annotation.coordinate = coordinate
            annotation.title = name
            annotation.subtitle = "Navi Destination"

            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: false)
        }
    }
}
