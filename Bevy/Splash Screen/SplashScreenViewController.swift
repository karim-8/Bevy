//
//  ViewController.swift
//  Bevy
//
//  Created by KarimAhmed on 21/10/2021.
//

import UIKit
import CoreData

class SplashScreenViewController: UIViewController {
    
    //MARK:- PROPERTIES
    private var bevyLogo = UIImageView()
    var viewModel: SplashScreenViewModel?
    private let coordinator = SplashScreenCoordinator()
    let persistant = PresesistancService.shared.context
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getEventsTypes()
        getEventsDataList()
        setBackGroundColor()
        createSplashLogo()
    }
    
    //MARK:- GET EVENTS TYPES
    func getEventsTypes() {
        viewModel?.getEventsData(linkType: .EventType)
    }
    
    //MARK:- GET EVENTS List Data
    func getEventsDataList() {
        viewModel?.getEventsData(linkType: .Eventdetails)
    }
    
    //MARK:- VIEW DID LAYOUT SUBVIEW
    override func viewDidLayoutSubviews() {
        bevyLogo.center = view.center
    }
    
    //MARK:- VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            let image = self.viewModel?.animateSplashLogo(view: self.view, bevyLogo: self.bevyLogo)
            self.bevyLogo = image!
        })
    }
    
    //MARK:- SETUP VIEW
    private func setupView() {
        viewModel = SplashScreenViewModel(coordinator: coordinator, view: self)
    }
    
    //MARK:- SET BACKGROUND COLOR
    private func setBackGroundColor() {
        view.backgroundColor = UIColor(red: 19/255, green: 224/255, blue: 220/255, alpha: 1.0)
    }
    
    //MARK:- CRETATE SPLASH LOGO
    private func createSplashLogo() {
        bevyLogo = {
            let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
            logoImage.image = UIImage(named: "bevy-logo")
            logoImage.sizeToFit()
            return logoImage
        }()
        view.addSubview(bevyLogo)
    }
    
    //MARK:- DEINIT
    deinit {
        viewModel = nil
    }
}
