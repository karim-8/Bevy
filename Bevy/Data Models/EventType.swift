//
//  EventType.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import Foundation

struct EventType : Codable {
    
    let name : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}
