//
//  SplashScreenViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import UIKit

class SplashScreenViewModel {
    
    //MARK:- PROPERTIES
    private let coordinator: SplashScreenCoordinator
    private let viewController: UIViewController
    
    //MARK:- INIT
    init(coordinator: SplashScreenCoordinator, view: UIViewController) {
        self.coordinator = coordinator
        self.viewController = view
    }
    
    //MARK:- ANIMATE SPLASH LOGO
    func animateSplashLogo(view: UIView, bevyLogo: UIImageView) -> UIImageView {
        UIView.animate(withDuration: 2, animations: {
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
        UIView.animate(withDuration: 3, animations: {
           bevyLogo.alpha = 0
        },completion: { animationDone in
            if animationDone {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    self.coordinator.navigateTo(view: self.viewController)
                })
            }
        })
    }
}
