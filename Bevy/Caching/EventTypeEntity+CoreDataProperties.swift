//
//  EventTypeEntity+CoreDataProperties.swift
//  Bevy
//
//  Created by KarimAhmed on 24/10/2021.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
extension EventTypeEntity: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventTypeEntity> {
        return NSFetchRequest<EventTypeEntity>(entityName: "EventTypeEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?

    

      // MARK: - Encodable
      public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(name, forKey: .name)
          try container.encode(id, forKey: .id)
      }
}

extension EventTypeEntity : Identifiable {

}
