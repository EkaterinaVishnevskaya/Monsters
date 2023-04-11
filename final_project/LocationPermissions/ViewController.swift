//
//  ViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 02.03.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        title = " "
        let image = UIImageView(image: UIImage(named: "Background1"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        checkLocationServiceEnabled()
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status == .restricted || status == .denied {
                navigationController?.pushViewController(DeniedViewController(), animated: true)
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                navigationController?.pushViewController(MapViewController(), animated: true)
                locationManager.stopUpdatingLocation()
            } else {
                navigationController?.pushViewController(PermissionViewController(), animated: true)
                locationManager.stopUpdatingLocation()
            }
        } else {
            let allert = UIAlertController(title: nil, message: "Для того, чтобы показать вас и ближайших монстров, разрешите доступ к вашей геопозиции", preferredStyle: .alert)
            let action = UIAlertAction(title: "Разрешить", style: .default) { _ in
                if let appSettings = URL(string: "App-prefs:root=LOCATION_SERVICES"), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkLocationServiceEnabled()
    }
}
