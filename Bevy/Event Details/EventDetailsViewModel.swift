//
//  EventDetailsViewModel.swift
//  Bevy
//
//  Created by KarimAhmed on 25/10/2021.
//

import UIKit

class EventDetailsViewModel {
    var buttonState = false
    
    func changeFavButtonState(state: Bool) -> Bool {
        return !state
        
       
    }
    
    func setButtonImage(state: Bool) -> UIImage {
        if !state {
            return UIImage(systemName: "star.fill") ?? UIImage()

        }else {
            return UIImage(systemName: "star") ?? UIImage()

        }
    }
}
