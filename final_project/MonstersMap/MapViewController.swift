//
//  MapViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 04.03.2023.
//

import UIKit
import CoreLocation
import MapKit
import Combine

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    let button = UIButton()
    let map = MKMapView()
    var model = MostersMapModel()
    let moveToMyLocationButton = UIButton()
    let zoom = UIView()
    let zoomInButton = UIButton()
    let zoomOutButton = UIButton()
    var f: Bool = true
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.model.updateMonsters()
            let annotations = Set(self.map.annotations.filter({ $0 !== self.map.userLocation }) as! [MonsterAnnotation])
            let newAnnotations = Set(self.model.getAnnotations())
            let annotationsToDelete = annotations.subtracting(newAnnotations)
            let annotationsToAdd = newAnnotations.subtracting(annotations)
            self.map.removeAnnotations(Array(annotationsToDelete))
            self.map.addAnnotations(Array(annotationsToAdd))
        }
        title = " "
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        map.delegate = self
        map.showsUserLocation = true
        map.isRotateEnabled = false
        map.userTrackingMode = .none
        map.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(map)
        map.setCenter(model.location.coordinate, animated: true)
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        button.setTitle("Моя команда", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor(named: "WB")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            button.heightAnchor.constraint(equalToConstant: 55)
            
        ])
        button.addTarget(self, action: #selector(myTeam), for: .touchUpInside)
        
        zoom.backgroundColor = UIColor(named: "WB")
        zoom.layer.cornerRadius = 5
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.setTitleColor(UIColor(named: "BW"), for: .normal)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.setTitleColor(UIColor(named: "BW"), for: .normal)
        zoom.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoom)
        zoom.addSubview(zoomInButton)
        zoom.addSubview(zoomOutButton)
        NSLayoutConstraint.activate([
            zoom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            zoom.widthAnchor.constraint(equalToConstant: 40),
            zoom.heightAnchor.constraint(equalToConstant: 80),
            zoom.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            zoomInButton.centerXAnchor.constraint(equalTo: zoom.centerXAnchor),
            zoomInButton.centerYAnchor.constraint(equalTo: zoom.centerYAnchor, constant: -20),
            zoomOutButton.centerXAnchor.constraint(equalTo: zoom.centerXAnchor),
            zoomOutButton.centerYAnchor.constraint(equalTo: zoom.centerYAnchor, constant: 20)
            
        ])
        
        let image = UIImage(named: "Position")?.withRenderingMode(.alwaysTemplate)
        moveToMyLocationButton.setImage(image, for: .normal)
        moveToMyLocationButton.tintColor = UIColor(named: "BW")
        moveToMyLocationButton.backgroundColor = UIColor(named: "WB")
        moveToMyLocationButton.translatesAutoresizingMaskIntoConstraints = false
        moveToMyLocationButton.layer.cornerRadius = 20
        view.addSubview(moveToMyLocationButton)
        NSLayoutConstraint.activate([
            moveToMyLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            moveToMyLocationButton.widthAnchor.constraint(equalToConstant: 40),
            moveToMyLocationButton.heightAnchor.constraint(equalToConstant: 40),
            moveToMyLocationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
        moveToMyLocationButton.addTarget(self, action: #selector(moveToMyLocation), for: .touchUpInside)
        
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if !CLLocationManager.locationServicesEnabled() {
            let allert = UIAlertController(title: nil, message: "Мы не знаем, где вы находитесь на карте, разрешите нам определить ваше местоположение. Это делается в настройках устройства", preferredStyle: .alert)
            let action = UIAlertAction(title: "Перейти в настройки", style: .cancel) { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied || status == .restricted || status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    @objc func moveToMyLocation() {
        let coordReg = MKCoordinateRegion(center: model.location.coordinate, span: map.region.span)
        map.setRegion(coordReg, animated: true)
    }
    
    @objc func zoomIn() {
        let centerLocation = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        let deltaLong = map.region.span.longitudeDelta*0.75
        let deltaLat = map.region.span.latitudeDelta*0.75
        let span = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        let coordReg = MKCoordinateRegion(center: centerLocation.coordinate, span: span)
        map.setRegion(coordReg, animated: true)
    }
    
    @objc func zoomOut() {
        let centerLocation = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        let deltaLong = map.region.span.longitudeDelta*1.25
        let deltaLat = map.region.span.latitudeDelta*1.25
        let span = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        let coordReg = MKCoordinateRegion(center: centerLocation.coordinate, span: span)
        map.setRegion(coordReg, animated: true)
    }
    
    @objc func myTeam() {
        navigationController?.pushViewController(TeamViewController(), animated: true)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        model.location = locations.last! as CLLocation
        if f {
            let coordReg = MKCoordinateRegion(
                        center: model.location.coordinate,
                        latitudinalMeters: 300,
                        longitudinalMeters: 300)
            map.setRegion(coordReg, animated: true)
            f = false
            model.generateMonsters()
            map.addAnnotations(model.getAnnotations())
        }
        let annotations = Set(map.annotations.filter({ $0 !== map.userLocation }) as! [MonsterAnnotation])
        let newAnnotations = Set(model.getAnnotations())
        let annotationsToDelete = annotations.subtracting(newAnnotations)
        let annotationsToAdd = newAnnotations.subtracting(annotations)
        map.removeAnnotations(Array(annotationsToDelete))
        map.addAnnotations(Array(annotationsToAdd))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !CLLocationManager.locationServicesEnabled() {
            let allert = UIAlertController(title: nil, message: "Мы не знаем, где вы находитесь на карте, разрешите нам определить ваше местоположение. Это делается в настройках устройства", preferredStyle: .alert)
            let action = UIAlertAction(title: "Перейти в настройки", style: .cancel) { _ in
                if let appSettings = URL(string: "App-prefs:root=LOCATION_SERVICES"), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
            let status = CLLocationManager.authorizationStatus()
            if status == .denied || status == .restricted || status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "Monster"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            let monsterAnnotation = annotation as! MonsterAnnotation
            annotationView.image = UIImage(named: monsterAnnotation.name + "_пин")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else {
            return
        }
        let position = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        let distance = model.location.distance(from: position)
        if distance > 100 {
            let allert = UIAlertController(title: nil, message: "Вы находитесь слишком далеко от монстра – \(Int(distance)) метров", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
            let monster = view.annotation as! MonsterAnnotation
            let vc = CatchViewController()
            vc.monster = monster
            navigationController?.pushViewController(vc, animated: true)
            map.removeAnnotation(view.annotation!)
            model.deleteMonster(monster: monster)
        }
    }
}
