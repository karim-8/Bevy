//
//  UserSessionManager.swift
//  Bevy
//
//  Created by KarimAhmed on 25/10/2021.
//

import Foundation

class UserSessionManager
{
    // MARK:- Properties

    public static var shared = UserSessionManager()

    var types: [EventType]
    {
        get
        {
            guard let data = UserDefaults.standard.data(forKey: "events") else { return [] }
            return (try? JSONDecoder().decode([EventType].self, from: data)) ?? []
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "events")
        }
    }
    
    var details: [EventData]
    {
        get
        {
            guard let data = UserDefaults.standard.data(forKey: "details") else { return [] }
            return (try? JSONDecoder().decode([EventData].self, from: data)) ?? []
        }
        set
        {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "details")
        }
    }

    // MARK:- Init

    private init(){}
}
