//
//  HomeEventsViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 23/10/2021.
//

import Foundation
import UIKit


class HomeEventsViewModel {
    
    
    //PROPERTIES
    var eventsTypes = [EventType]()
    var eventDetails = [EventData]()

    //MARK:- GET EVENTS DATA
    func getEventsData(linkType: UrlEndPoints, pageIndex: Int, type: String) {
        let parameters = linkType == UrlEndPoints.EventType ? "" : "?event_type=\(type)" + "&page=\(pageIndex)"
        let url = Request(url: linkType.rawValue, param: parameters)
        NetworkClient().get(request: url) { [weak self] result in
            switch result {
            case .success(let event):
                self?.decodeResult(jsonData: event,link: linkType, index: pageIndex)
            case .failure(let error):
                print("Error in VM... \(error)")
            }
        }
    }
    
    //MARK:- DECODE JSON RESULT
    func decodeResult(jsonData: Data, link: UrlEndPoints, index: Int) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let eventsData = try? decoder.decode([EventData].self, from: jsonData)
        if let events = eventsData {
            if index == 0 {
                self.eventDetails.removeAll()
            }
            self.eventDetails.append(contentsOf: events)
        }
    }
    
    //MARK:- GET EVENT DETAILS
    func getEventDetails() -> [EventData] {
        return self.eventDetails
    }
    
    //MARK:- GET SWIPING PAGE
    func getSwipigPage(countriesTable: UITableView, scrollView: UIScrollView, currentPageIndex: Int, eventType: String) -> Int{
        
        var pageIndex = currentPageIndex
        let position = scrollView.contentOffset.y

        if position > (countriesTable.contentSize.height-100-scrollView.frame.size.height) {
           
            if pageIndex == 4 {
                pageIndex = 3
                
            }else {
                if currentPageIndex < 3 {
                    pageIndex += 1
                    
                    getEventsData(linkType: .Eventdetails, pageIndex: currentPageIndex, type: eventType)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let updatedEvents = self.getEventDetails()
                        self.eventDetails = updatedEvents
                        countriesTable.reloadData()
                    }
                }
            }
        }
        return pageIndex
    }
}
