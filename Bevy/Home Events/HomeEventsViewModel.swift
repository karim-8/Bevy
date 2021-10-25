//
//  HomeEventsViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 23/10/2021.
//

import Foundation



class HomeEventsViewModel {
    
    
    //PROPERTIES
    var eventsTypes = [EventType]()
    var eventDetails = [EventData]()

    //MARK:- GET EVENTS DATA
    func getEventsData(linkType: UrlEndPoints, pageIndex: Int, type: String) {
        let parameters = linkType == UrlEndPoints.EventType ? "" : "?event_type=\(type)" + "&page=\(pageIndex)"
        let url = Request(url: linkType.rawValue, param: parameters)
        //print("The url is..\(url)")
        NetworkClient().get(request: url) { [weak self] result in
            switch result {
            case .success(let event):
                self?.decodeResult(jsonData: event,link: linkType)
            case .failure(let error):
                print("Error in VM... \(error)")
            }
        }
    }
    
    //MARK:- DECODE JSON RESULT
    func decodeResult(jsonData: Data, link: UrlEndPoints) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let eventsData = try? decoder.decode([EventData].self, from: jsonData)
        if let events = eventsData {
            self.eventDetails.removeAll()
            self.eventDetails.append(contentsOf: events)
        }
    }
    
    func getEventDetails() -> [EventData] {
        return self.eventDetails
    }
}
