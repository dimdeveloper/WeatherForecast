//
//  ForecastCollectionViewLayout.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation
import UIKit

class ForecastCollectionViewLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    private let cellHeight: CGFloat = 85.0

    // MARK: Layout Overrides

    /// - Tag: ColumnFlowExample
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        
        
        //self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 8.0, bottom: 0.0, right: 8.0)
        self.sectionInsetReference = .fromSafeArea
    }
    
}
