//
//  ForecastCollectionViewCell.swift
//  UICollectionViewWithMVP
//
//  Created by TheMacUser on 02.09.2021.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thermometer: UIImageView!
    @IBOutlet weak var parentCellStackView: UIView!
    @IBOutlet weak var imageForecast: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var precipitationPropabilityLabel: UILabel!
    
}
