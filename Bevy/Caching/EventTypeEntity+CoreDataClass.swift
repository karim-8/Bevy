//
//  EventTypeEntity+CoreDataClass.swift
//  Bevy
//
//  Created by KarimAhmed on 24/10/2021.
//
//

import Foundation
import CoreData

@objc(EventTypeEntity)
public class EventTypeEntity: NSManagedObject {
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "EventTypeEntity", in: managedObjectContext)
        
        else {
            fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        
    }
}
