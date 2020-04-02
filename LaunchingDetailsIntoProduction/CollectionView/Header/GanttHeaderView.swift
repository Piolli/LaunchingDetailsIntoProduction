//
//  GanttHeaderView.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 01.04.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation

import UIKit

class GanttHeaderView : UICollectionReusableView {
    
    var zoomValue = CGFloat(0)
    var cellWidth = CGFloat(0)
    let defaultFontSize = CGFloat(12)
    var scaledFontSize = CGFloat(0)
    
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
        backgroundColor = .blue
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
        
        for i in 0..<countOfLabels {
            let label = UILabel(frame: CGRect(x: cellWidth * CGFloat(i), y: 0, width: cellWidth, height: frame.size.height))
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
        
        for i in 0..<countOfCells {
            let label = labels[i]
            label.frame = CGRect(x: cellWidth * CGFloat(i), y: 0, width: cellWidth, height: frame.size.height)
            label.font = .systemFont(ofSize: scaledFontSize)
        }
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attrs = layoutAttributes as? GanttHeaderViewLayoutAttributes {
            zoomValue = attrs.zoomValue
            cellWidth = GanttLayout.DefaultLayoutMetrics.cellWidth * zoomValue
            scaledFontSize = defaultFontSize * zoomValue
            if cellWidth != 0 {
                countOfCells = Int(frame.size.width/cellWidth)
            } else {
                print("cellWidth = 0!")
            }
        }
    }
    
}
