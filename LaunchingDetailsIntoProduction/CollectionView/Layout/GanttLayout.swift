//
//  GanttLayout.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 23.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

class GanttLayout: UICollectionViewLayout {

    enum DefaultLayoutMetrics {
        static var timeHeaderHeight = CGFloat(50)
        static var rowHeight = CGFloat(75)
        static var cellWidth = CGFloat(25)
    }
    
    struct LayoutMetrics {
        var timeHeaderHeight = DefaultLayoutMetrics.timeHeaderHeight
        var rowHeight = DefaultLayoutMetrics.rowHeight
        //It's been using for horizontal time axis at the header
        var cellWidth = DefaultLayoutMetrics.cellWidth
        
        mutating func scale(to value: CGFloat) {
            rowHeight = DefaultLayoutMetrics.rowHeight * value
            cellWidth = DefaultLayoutMetrics.cellWidth * value
        }
    }
    
    var cache: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    var items: [[Detail]] = [] {
        didSet {
            invalidateLayout()
        }
    }
    
    var layoutMetrics: LayoutMetrics = .init() {
        didSet {
            invalidateLayout()
        }
    }
    
    init(items: [[Detail]]) {
        super.init()
        self.items = items
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        var yOffsets: [CGFloat] = []
        for row in 0..<items.count {
            yOffsets.append(CGFloat(row) * layoutMetrics.rowHeight)
        }
        
        var xoffsets: [CGFloat] = Array.init(repeating: 0, count: items.count)
        var rowIndex = 0
        for itemInRowIndex in 0..<items[rowIndex].count {
            rowIndex = 0
            for _ in 0..<items.count {
                
                let indexPath = IndexPath(row: rowIndex, section: itemInRowIndex)
                let itemAttrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                let item = items[rowIndex][itemInRowIndex]
                
                print(item)
                print(indexPath)
                print("-----")
                
                let itemWidth = layoutMetrics.cellWidth * CGFloat(item.timeOnMachines[rowIndex])
                
                if rowIndex > 0 {
                    let topRowOffsets = xoffsets[rowIndex-1]
                    if topRowOffsets > xoffsets[rowIndex] {
//                        xoffsets[rowIndex] += xoffsets[rowIndex]
                        if itemInRowIndex + 1 < items[rowIndex].count {
                            items[rowIndex][itemInRowIndex].leftOffset = xoffsets[rowIndex-1] - (xoffsets[rowIndex])
//                            items[rowIndex][itemInRowIndex].leftOffset += itemWidth
                            items[rowIndex][itemInRowIndex].leftOffset /= layoutMetrics.cellWidth
                        }
                        //if last item in row
                        else if itemInRowIndex == items[rowIndex].count - 1 && topRowOffsets > xoffsets[rowIndex] {
                            items[rowIndex][itemInRowIndex].leftOffset = xoffsets[rowIndex-1] - (xoffsets[rowIndex])
                            items[rowIndex][itemInRowIndex].leftOffset /= layoutMetrics.cellWidth
                        }
                    }
                    
                }
                
                let newItem = items[rowIndex][itemInRowIndex]
                xoffsets[rowIndex] += newItem.leftOffset * layoutMetrics.cellWidth
                
                let frame = CGRect(x: xoffsets[rowIndex], y: yOffsets[rowIndex], width: itemWidth, height: layoutMetrics.rowHeight)
                itemAttrs.frame = frame
                cache[indexPath] = itemAttrs
                
                xoffsets[rowIndex] += itemWidth
                rowIndex += 1
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        //compute estimated width of max time
        let sectionsCount = collectionView!.numberOfSections
        if sectionsCount == 0 {
            return .zero
        }

        let width = CGFloat(5000)
        
        let itemsCount = collectionView!.numberOfItems(inSection: 0)
        let height = layoutMetrics.timeHeaderHeight + (layoutMetrics.rowHeight * CGFloat(itemsCount))
//        let height = CGFloat(1000)
        
        return .init(width: width, height: height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var atts: [UICollectionViewLayoutAttributes] = []
        for (_, layoutAttrs) in cache {
            if rect.intersects(layoutAttrs.frame) {
                atts.append(layoutAttrs)
            }
        }
        
        return atts
    }
}
