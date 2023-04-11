//
//  PermissionViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 04.03.2023.
//

import UIKit
import CoreLocation

class PermissionViewController: UIViewController {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        title = " "
        
        let image = UIImageView(image: UIImage(named: "Background1"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -screenWidth*0.75),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

}

extension PermissionViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("allowed")
            navigationController?.pushViewController(MapViewController(), animated: true)
            
        } else if status == .denied || status == .restricted {
            print("denied")
            navigationController?.pushViewController(DeniedViewController(), animated: true)
        }
    }
}
