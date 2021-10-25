//
//  EventHomeTableViewCell.swift
//  Bevy
//
//  Created by KarimAhmed on 26/10/2021.
//

import UIKit

class EventHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eventdate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configreImage(image: String) {
        let imageUrlString = image
        guard let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
        eventImage.loadImge(withUrl: imageUrl)
    }
}
