//
//  HomeEventsViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 23/10/2021.
//

import Foundation



class HomeEventsViewModel {
    
    let coordinator: HomeEventsCoordinator?
    
    init(coordinator: HomeEventsCoordinator) {
        self.coordinator = coordinator
    }
    
    //PROPERTIES
    var eventsTypes = [EventType]()
    

    
    func getEventsTypes() -> [EventType] {
        return eventsTypes
    }
    
    func getEventsCount() -> Int {
        return eventsTypes.count
    }
}
