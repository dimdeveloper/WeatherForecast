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
        let availableHeight = collectionView.bounds.inset(by: collectionView.layoutMargins).height
        let contentHeight = collectionView.contentSize.height
        let cellWidth = availableWidth.rounded(.down)
        let topInset = (availableHeight-contentHeight)/2
        self.itemSize.width = cellWidth
        
        self.sectionInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea    }
    
}
