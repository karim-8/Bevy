//
//  MenuBarCollectionViewCell.swift
//  Bevy
//
//  Created by KarimAhmed on 17/11/2021.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var menuItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuItemTitle.backgroundColor = .clear
        menuItemTitle.alpha = 0.6
    }
    
    func setupCell(text: String) {
        menuItemTitle.text = text
    }
    
    override var isSelected: Bool {
        didSet{
            menuItemTitle.alpha = isSelected ? 1.0 : 0.6
        }
    }
}
