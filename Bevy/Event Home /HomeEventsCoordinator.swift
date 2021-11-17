//
//  HomeEventsCoordinator.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

class HomeEventsCoordinator {
    
    //MARK:- PROPERTIES
    var eventDetailsViewController: EventDetailsViewController?
    var navigationController: UINavigationController?
    
    //MARK:- INIT
    init(view: EventDetailsViewController, navigation: UINavigationController) {
        eventDetailsViewController = view
        navigationController = navigation
    }
        
    //MARK:- NAVIGATE TO
    func navigateTo(searchController: UISearchController, filteredEvent: [EventData], eventDetails: [EventData], indexPath: IndexPath ) {
        
        eventDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? EventDetailsViewController ?? EventDetailsViewController()
        if (searchController.isActive) {
            eventDetailsViewController?.detailsItems = filteredEvent[indexPath.row]
        }else {
            eventDetailsViewController?.detailsItems = eventDetails[indexPath.row]
        }
        navigationController?.pushViewController(eventDetailsViewController ?? UIViewController(), animated: true)
    }
}
