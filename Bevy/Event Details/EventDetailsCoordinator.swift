//
//  EventDetailsCoordinator.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

class EventDetailsCoordinator {
    
    //MARK:- PROPERTIES
    var navigationItemController: UINavigationController?
    var viewController: EventDetailsViewController?
    
    //MARK:- INIT
    init(view: EventDetailsViewController, naviagtion: UINavigationController) {
        navigationItemController = naviagtion
        viewController = view
    }
    
    //MARK:- POP VIEW CONTROLLER
    func popViewController() {
        navigationItemController?.popViewController(animated: true)
    }
}
