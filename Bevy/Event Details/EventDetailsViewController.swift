//
//  EventDetailsViewController.swift
//  Bevy
//
//  Created by KarimAhmed on 23/10/2021.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    //MARK:- PROPERTIES
    @IBOutlet weak var customHeaderView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    var favouriteTapped = false
    var detailsItems: EventData?
    var viewModel: EventDetailsViewModel?
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setEventDetailsData() 
    }
    
    //MARK:- SET EVENT DETAILS
    func setEventDetailsData() {
        self.eventName.text = detailsItems?.name
        self.eventDescription.text = detailsItems?.description
    }
    
    //MARK:- BACK BUTTON TAPPED
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- FAVOURITE BUTTON TAPPED
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        let value = viewModel?.changeFavButtonState(state: favouriteTapped)
        favouriteTapped = value!
        favouriteButton.setImage(viewModel?.setButtonImage(state: value!), for: .normal)
    }
}



