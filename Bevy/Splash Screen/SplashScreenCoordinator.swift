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
        let homeViewController = HomeScreenViewController()
        homeViewController.modalTransitionStyle = .crossDissolve
        homeViewController.modalPresentationStyle = .fullScreen
        view.present(homeViewController, animated: true, completion: nil)
    }
}
