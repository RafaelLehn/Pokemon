//
//  ErrorCollectionViewCell.swift
//  Poke-app
//
//  Created by Rafael on 7/13/22.
//

import UIKit

protocol ErrorCollectionViewCellDelegate {
    func tryAgain()
}

class ErrorCollectionViewCell: UICollectionViewCell {
    
    var delegate: ErrorCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.delegate?.tryAgain()
    }
    
}
