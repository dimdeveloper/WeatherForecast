//
//  ForecastCollectionViewLayout.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import Foundation
import UIKit

class ForecastCollectionViewLayout: UICollectionViewFlowLayout{
    

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let cellWidth = availableWidth.rounded(.down)
        self.itemSize.width = cellWidth
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
    
}
