//
//  Monsters+CoreDataProperties.swift
//  final_project
//
//  Created by Екатерина Вишневская on 05.03.2023.
//
//

import Foundation
import CoreData


extension Monsters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Monsters> {
        return NSFetchRequest<Monsters>(entityName: "Monsters")
    }

    @NSManaged public var name: String?
    @NSManaged public var level: Int16

}
