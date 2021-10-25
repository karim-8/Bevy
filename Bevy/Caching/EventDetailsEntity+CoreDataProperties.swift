//
//  EventDetailsEntity+CoreDataProperties.swift
//  Bevy
//
//  Created by KarimAhmed on 24/10/2021.
//
//

import Foundation
import CoreData


extension EventDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventDetailsEntity> {
        return NSFetchRequest<EventDetailsEntity>(entityName: "EventDetailsEntity")
    }

    @NSManaged public var longitude: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var latitude: String?
    @NSManaged public var end_date: String?
    @NSManaged public var start_date: String?
    @NSManaged public var cover: String?
    @NSManaged public var name: String?
    @NSManaged public var id: String?

}

extension EventDetailsEntity : Identifiable {

}
