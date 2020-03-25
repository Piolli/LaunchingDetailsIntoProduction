//
//  GanttCell.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 25.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

class GanttCell: UICollectionViewCell {
    
    let numberOfTask: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    func addNumberOfTasks(text: String) {
        contentView.addSubview(numberOfTask)
        numberOfTask.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberOfTask.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        numberOfTask.text = text
        
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 2.0
    }
    
}
