//
//  SplashScreenViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import UIKit
import CoreData

//MARK:- URL END POINTS
enum UrlEndPoints: String {
    case EventType =    "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes"
    case Eventdetails = "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/events"
}

//MARK:- REQUEST
struct Request: RequestProtocol {
    let eventsUrl: String?
    let params: String?
    init(url: String, param: String) {
        self.eventsUrl = url
        self.params = param
    }
    var url: URL {
        return URL(string: self.eventsUrl! + self.params!)!
    }
}

class SplashScreenViewModel {
    
    //MARK:- PROPERTIES
    private let coordinator: SplashScreenCoordinator
    private let viewController: UIViewController
    var eventsTypes = [EventType]()
    var eventDetails = [EventData]()
    let presistance = PresesistancService.shared
    
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
    func getEventsData(linkType: UrlEndPoints) {
        let url = Request(url: linkType.rawValue, param: "")
        NetworkClient().get(request: url) { [weak self] result in
            switch result {
            case .success(let event):
                self?.decodeResult(jsonData: event,link: linkType)
            case .failure(let error):
                print("Error in VM... \(error)")
                self?.fetchData(link: linkType)
            }
        }
    }
    
    //MARK:- DECODE JSON RESULT
    func decodeResult(jsonData: Data, link: UrlEndPoints) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        if link == UrlEndPoints.EventType {
            self.savingDBObject(jsonData: jsonData, types: link)
            let eventsData = try? decoder.decode([EventType].self, from: jsonData)
            if let events = eventsData {
                self.eventsTypes.append(contentsOf: events)
            }
        }else {
            self.savingDBObject(jsonData: jsonData, types: link)
            let eventsData = try? decoder.decode([EventData].self, from: jsonData)
            if let events = eventsData {
                self.eventDetails.append(contentsOf: events)
            }
        }
    }
    
    //MARK:- SAVING IN CORE DATA
    func savingDBObject(jsonData: Data, types: UrlEndPoints) {
        do {
            guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {return}
            if types == UrlEndPoints.EventType {
                let _ : [EventTypeEntity] = jsonArray.compactMap { [weak self] in
                    guard let self = self,
                          let name = $0["name"] as? String,
                          let id = $0["id"] as? String
                    else {return nil}
                    
                    let eventObj = EventTypeEntity(context: self.presistance.context)
                    eventObj.name = name
                    eventObj.id = id
                    return eventObj
                }
                self.presistance.saveContext()
            }
            else {
                let _ : [EventDetailsEntity] = jsonArray.compactMap { [weak self] in
                    guard let self = self,
                          let name = $0["name"] as? String,
                          let id = $0["id"] as? String,
                          let long = $0["longitude"] as? String,
                          let lat = $0["latitude"] as? String,
                          let endDate = $0["end_date"] as? String,
                          let startDate = $0["start_date"] as? String,
                          let description = $0["description"] as? String,
                          let cover = $0["cover"] as? String
                    else {return nil}
                    let eventObj = EventDetailsEntity(context: self.presistance.context)
                    eventObj.name = name
                    eventObj.id = id
                    eventObj.latitude = lat
                    eventObj.longitude = long
                    eventObj.end_date = endDate
                    eventObj.start_date = startDate
                    eventObj.descriptions = description
                    eventObj.cover = cover
                    return eventObj
                }
                self.presistance.saveContext()
            }
        } catch {
            print("Error Saving Object in DataBase")
        }
    }
    
    //MARK:- Fetching FROM CORE DATA
    func fetchData(link: UrlEndPoints) {
        let fetchRequest: NSFetchRequest<EventTypeEntity> = EventTypeEntity.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let event = try! PresesistancService.shared.context.fetch(fetchRequest)
        var typesObj: EventType = EventType()
        if link == UrlEndPoints.EventType {
            let _: [EventTypeEntity] = event.compactMap { [weak self] in
                guard let self = self,
                      let name = $0.name,
                      let id = $0.id
                else {return nil}
                typesObj.name = name
                typesObj.id = id
                self.eventsTypes.append(typesObj)
                return EventTypeEntity()
            }
        }else {
            let fetchRequest: NSFetchRequest<EventDetailsEntity> = EventDetailsEntity.fetchRequest()
            let event = try! PresesistancService.shared.context.fetch(fetchRequest)
            var detailsObject: EventData = EventData()
            let _: [EventDetailsEntity] = event.compactMap { [weak self] in
                guard let self = self,
                      let name = $0.name,
                      let id = $0.id,
                      let lat = $0.latitude,
                      let long = $0.longitude,
                      let des = $0.descriptions,
                      let cover = $0.cover,
                      let startDate = $0.start_date,
                      let endDate = $0.end_date
                else {return nil}
                detailsObject.name = name
                detailsObject.id = id
                detailsObject.cover = cover
                detailsObject.description = des
                detailsObject.latitude = lat
                detailsObject.longitude = long
                detailsObject.start_date = startDate
                detailsObject.end_date = endDate
                self.eventDetails.append(detailsObject)
                return EventDetailsEntity()
            }
        }
    }
}

