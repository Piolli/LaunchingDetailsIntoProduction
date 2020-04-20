//
//  GanttLeadingView.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 02.04.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

class GanttLeadingView: UICollectionReusableView {
    
    var zoomValue = CGFloat(0)
    var cellWidth = CGFloat(0)
    let defaultFontSize = CGFloat(14)
    var scaledFontSize = CGFloat(0)
    var rowHeight = CGFloat(75)
    var topOffset = CGFloat(0)
    
    var countOfCells = 0 {
        willSet {
            if newValue > self.countOfCells {
                initLabels(withCount: newValue)
            }
        }
    }
    
    var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLabels(withCount countOfLabels: Int) {
        if zoomValue == 0 || cellWidth == 0 {
            return
        }
        
        labels.forEach { (label) in
            label.removeFromSuperview()
        }
        labels.removeAll()
        var yOffset = topOffset
        for i in 0..<countOfLabels {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: rowHeight)
            yOffset += rowHeight
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(i+1)"
            label.textAlignment = .center
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.font = .systemFont(ofSize: scaledFontSize)
            addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if countOfCells == 0 {
            return
        }
        
        var yOffset = topOffset
        for i in 0..<countOfCells {
            let label = labels[i]
            label.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: rowHeight)
            yOffset += rowHeight
            label.font = .systemFont(ofSize: scaledFontSize)
        }
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attrs = layoutAttributes as? GanttHeaderViewLayoutAttributes {
            zoomValue = attrs.zoomValue
            cellWidth = GanttLayout.DefaultLayoutMetrics.cellWidth * zoomValue
            scaledFontSize = defaultFontSize * zoomValue
            rowHeight = attrs.rowHeight
            countOfCells = attrs.countOfCells
            topOffset = attrs.topOffset
        }
    }
    
}
