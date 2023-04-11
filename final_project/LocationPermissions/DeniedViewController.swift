//
//  DeniedViewController.swift
//  final_project
//
//  Created by Екатерина Вишневская on 04.03.2023.
//

import UIKit
import CoreLocation

class DeniedViewController: UIViewController {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        title = " "
        
        locationManager.delegate = self
        
        let image = UIImageView(image: UIImage(named: "Background1"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -screenWidth*1.5),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let allert = UIAlertController(title: nil, message: "Мы не знаем, где вы находитесь на карте, разрешите нам определить ваше местоположение. Это делается в настройках устройства", preferredStyle: .alert)
        let action = UIAlertAction(title: "Перейти в настройки", style: .cancel) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
        allert.addAction(action)
        self.present(allert, animated: true, completion: nil)
    }

}

extension DeniedViewController: CLLocationManagerDelegate {
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

