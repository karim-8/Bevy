//
//  SplashScreenViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import UIKit

enum urlLinks: String {
    case EventType = "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes"
    case Eventdetails = "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/events?event_type"
}

struct Request: RequestProtocol {
    let eventsUrl: String?
    
    init(url: String) {
        self.eventsUrl = url
    }
    
    //let eventsUrl = "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes"
    var url: URL {
        return URL(string: self.eventsUrl!)!
    }
}

class SplashScreenViewModel {
    
    //MARK:- PROPERTIES
    private let coordinator: SplashScreenCoordinator
    private let viewController: UIViewController
    var eventsTypes = [EventType]()
    var eventDetails = [EventData]()
    
    //MARK:- INIT
    init(coordinator: SplashScreenCoordinator, view: UIViewController) {
        self.coordinator = coordinator
        self.viewController = view
    }
    
    //MARK:- ANIMATE SPLASH LOGO
    func animateSplashLogo(view: UIView, bevyLogo: UIImageView) -> UIImageView {
        UIView.animate(withDuration: 5, animations: {
            let size = view.frame.size.width * 3
            let xScale = size - view.frame.size.width
            let yScale = view.frame.size.height - size
            
            bevyLogo.frame = CGRect(
                x: -(xScale/2),
                y: yScale/2,
                width: size,
                height: size
            )
        })
        animationExcution(view: view, bevyLogo: bevyLogo)
        return bevyLogo
    }
    
    //MARK:- ANIMATION EXCUTION
    func animationExcution(view: UIView, bevyLogo: UIImageView) {
        UIView.animate(withDuration: 5, animations: {
            bevyLogo.alpha = 0
        },completion: { animationDone in
            if animationDone {
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    self.coordinator.navigateTo(view: self.viewController, eventTypeData: self.eventsTypes, eventsdetails: self.eventDetails)
                })
            }
        })
    }
    
    //MARK:- GET EVENTS DATA
    func getEventsData(linkType: urlLinks) {
        //let urlLink = linkType.EventType
        let url = Request(url: linkType.rawValue)
        NetworkClient().get(request: url) { [weak self] result in
            switch result {
            case .success(let event):
                self?.decodeResult(jsonData: event,link: linkType)
            case .failure(let error):
                print("Error in VM... \(error)")
            }
        }
    }
    
    func decodeResult(jsonData: Data, link: urlLinks) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        if link == urlLinks.EventType {
            let eventsData = try? decoder.decode([EventType].self, from: jsonData)
            if let events = eventsData {
                self.eventsTypes.append(contentsOf: events)
            }
        }else {
            let eventsData = try? decoder.decode([EventData].self, from: jsonData)
            if let events = eventsData {
                self.eventDetails.append(contentsOf: events)
      }
    }
  }
}
