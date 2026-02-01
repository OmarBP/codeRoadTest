//
//  CustomCollectionFlowLayout.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import UIKit

/**
 Custom flow layout for a collection view that allows cells to auto adapt the layout to the cell size, and keeping desired sections woth the default flow layout
 */
class CustomCollectionFlowLayout: UICollectionViewFlowLayout {
    var unaffectedSections = Set<Int>()
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        minimumLineSpacing = 8
        sectionInset = .zero
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            guard !unaffectedSections.contains(layoutAttribute.indexPath.section) else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + 8
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        false
    }
}
