//
//  RatingViewCell.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import UIKit

class RatingViewCell: UICollectionViewCell {
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProgress(_ progress: String, source: String) {
        let convertedProgress = convertProgress(progress)
        ratingView.progressLabel.text = progress
        ratingView.sourceLabel.text = source
        DispatchQueue.main.async { [weak self] in
            self?.ratingView.setProgress(convertedProgress)
        }
    }
    
    fileprivate func convertProgress(_ progress: String) -> Double {
        if let match = progress.firstMatch(of: /(\d+)%/) {
            let value = match.output.0.replacingOccurrences(of: "%", with: "")
            return (Double(value) ?? 0) / 100
        }
        if let match = progress.firstMatch(of: /(\d+)\/(\d+)/) {
            let fraction = match.output.0.split(separator: "/")
            guard let divisor = fraction.first, let dividend = fraction.last else {
                return 0
            }
            let divisorValue = Double(divisor) ?? 0
            let dividendValue = Double(dividend) ?? 0
            return divisorValue / dividendValue
        }
        return 0
    }
}
