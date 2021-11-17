//
//  HomeEventsCoordinator.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

class HomeEventsCoordinator {
    
    //Inject the models
  //  HomeEventsCoordinator()
    //[EventData]

    func navigateTo(view: UIViewController, searchController: UISearchController, filteredEvent: [EventData], eventDetails: [EventData], indexPath: IndexPath, navigationController: UINavigationController ) {
        
        var eventDetailsViewController = EventDetailsViewController()
        
        eventDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? EventDetailsViewController ?? EventDetailsViewController()

        if (searchController.isActive) {
            eventDetailsViewController.detailsItems = filteredEvent[indexPath.row]
        }else {
            eventDetailsViewController.detailsItems = eventDetails[indexPath.row]
        }
        eventDetailsViewController.viewModel = EventDetailsViewModel()
        navigationController.pushViewController(eventDetailsViewController, animated: true)
        
    }

}

/*
 let navigationController = UINavigationController(rootViewController: homeViewController!)
 navigationController.modalTransitionStyle = .crossDissolve
 navigationController.modalPresentationStyle = .fullScreen
 view.present(navigationController, animated: true, completion: nil)
 */
