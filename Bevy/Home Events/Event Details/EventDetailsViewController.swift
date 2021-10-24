//
//  EventDetailsViewController.swift
//  Bevy
//
//  Created by KarimAhmed on 23/10/2021.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var favouriteTapped = false
    
    @IBOutlet weak var customHeaderView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var detailsItems: EventData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setEventDetailsData() 
    }
    
    func setEventDetailsData() {
        self.eventName.text = detailsItems?.name
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        if !favouriteTapped {
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favouriteTapped = true
        }else {
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favouriteTapped = false
        }
    }
}



