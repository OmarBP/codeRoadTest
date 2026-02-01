//
//  MovieViewCell.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

/**
 Custom table view cell that shows some data about a movie or serie
 */
class MovieViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        poster.layer.cornerRadius = 8
        poster.clipsToBounds = true
        poster.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
