//
//  MenuCell.swift
//  Bevy
//
//  Created by KarimAhmed on 22/10/2021.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.backgroundColor = .red
        titleLabel.alpha = 0.6
    }
    
    func setupCell(text: String) {
        titleLabel.text = text
    }
    
    override var isSelected: Bool {
        didSet{
            titleLabel.alpha = isSelected ? 1.0 : 0.6
        }
    }
    
}
