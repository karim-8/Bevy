//
//  EventTypeEntity+CoreDataProperties.swift
//  Bevy
//
//  Created by KarimAhmed on 24/10/2021.
//
//

import Foundation
import CoreData


extension EventTypeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventTypeEntity> {
        return NSFetchRequest<EventTypeEntity>(entityName: "EventTypeEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?

}

extension EventTypeEntity : Identifiable {

}
