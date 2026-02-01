//
//  GenreViewCell.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

/**
 Custom collecion view cell that auto adapts its size to its content
 */
class GenreViewCell: UICollectionViewCell {
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var genreTitleLabelWidthConstraint: NSLayoutConstraint! {
        didSet {
            genreTitleLabelWidthConstraint.isActive = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        backgroundColor = .white
        genreTitleLabel.textColor = .darkGray
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftAnchor = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightAnchor = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topAnchor = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftAnchor, rightAnchor, topAnchor, bottomAnchor])
    }
}
