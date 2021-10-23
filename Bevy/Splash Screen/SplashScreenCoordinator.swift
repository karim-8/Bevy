//
//  SplashScreenCoordinator.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import UIKit

class SplashScreenCoordinator {
    
    //MARK:- NAVIGATE TO
    func navigateTo(view: UIViewController) {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? HomeEventsViewController
        let navigationController = UINavigationController(rootViewController: homeViewController!)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        view.present(navigationController, animated: true, completion: nil)
    }
}

