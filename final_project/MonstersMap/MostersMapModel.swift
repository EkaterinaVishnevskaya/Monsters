//
//  MostersMapModel.swift
//  final_project
//
//  Created by Екатерина Вишневская on 05.03.2023.
//

import UIKit
import CoreLocation
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
    var title: String?
    var name: String
    var level: Int = 0
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}

let names = ["Сплюшка", "Гиппо", "Вулканчик", "Зомбик", "Драко", "Щекан", "Желтухин", "Болотник", "Уголёк", "Эмо"]

class MostersMapModel {
    var monsters: [MonsterAnnotation] = []
    var location: CLLocation = CLLocation() 
    
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = location.coordinate.longitude
        let currentLat = location.coordinate.latitude

        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000

        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)

        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)

        //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)

        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        } else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        } else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        } else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        } else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        } else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }

    }
    
    func newMonster() -> MonsterAnnotation {
        let name = names[Int.random(in: 0..<10)]
        let randCordinate = generateRandomCoordinates(min: 0, max: 1000)
        return MonsterAnnotation(name: name, coordinate: randCordinate)
    }
    
    func generateMonsters() {
        for _ in 0..<30 {
            monsters.append(newMonster())
        }
    }
    
    func updateMonsters() {
        monsters = monsters.filter { monster in
            let prob = Int.random(in: 0..<10)
            return prob >= 2
        }
        for _ in 0..<6 {
            monsters.append(newMonster())
        }
    }
    
    func getAnnotations() -> [MonsterAnnotation] {
        return monsters.filter{ monster in
            let monsterLocaltion = CLLocation(latitude: monster.coordinate.latitude, longitude: monster.coordinate.longitude)
            let distance = location.distance(from: monsterLocaltion)
            return distance < 300
        }
        
    }
    
    func deleteMonster(monster: MonsterAnnotation) {
        monsters = monsters.filter { $0 != monster }
    }
}
