//
//  HomeEventsViewController+UITableView.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

//MARK:- EVENTS TABLE VIEW DELEGATE & DATA SOURCE
extension HomeEventsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredEvent.count
        }
        return eventDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventHomeTableViewCell
            cell?.eventName.text = filteredEvent[indexPath.row].name
            cell?.descriptionLabel.text = filteredEvent[indexPath.row].description
            cell?.eventdate.text = filteredEvent[indexPath.row].start_date ?? "12 April"
            cell?.configreImage(image: filteredEvent[indexPath.row].cover ?? "")
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventHomeTableViewCell
            cell?.eventName.text = eventDetails?[indexPath.row].name
            cell?.descriptionLabel.text = eventDetails?[indexPath.row].description
            cell?.eventdate.text = eventDetails?[indexPath.row].start_date ?? "12 April"
            cell?.configreImage(image: eventDetails?[indexPath.row].cover ?? "")
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var eventDetailsViewController = EventDetailsViewController()
        
        eventDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? EventDetailsViewController ?? EventDetailsViewController()
        
        
        if (searchController.isActive) {
            eventDetailsViewController.detailsItems = filteredEvent[indexPath.row]
        }else {
            eventDetailsViewController.detailsItems = eventDetails?[indexPath.row]
        }
        eventDetailsViewController.viewModel = EventDetailsViewModel()
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
