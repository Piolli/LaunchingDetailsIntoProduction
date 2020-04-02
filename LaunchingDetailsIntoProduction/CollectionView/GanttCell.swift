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
        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    func addNumberOfTasks(text: String, fontSize: CGFloat) {
        contentView.addSubview(numberOfTask)
        numberOfTask.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberOfTask.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        numberOfTask.text = text
        numberOfTask.font = .systemFont(ofSize: fontSize)
        
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
}
