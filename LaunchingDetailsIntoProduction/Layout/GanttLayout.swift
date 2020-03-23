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
    
    typealias Algorithm = ([Detail]) -> [Detail]

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
    var items: [[Detail]] = []
    
    var layoutMetrics: LayoutMetrics = .init() {
        didSet {
            invalidateLayout()
        }
    }
    
    init(details: [Detail], algorithm: Algorithm) {
        super.init()
        items = prepareItems(items: details, algorithm: algorithm)
    }
    
    /// Prepare items for displaying
    /// - Parameters:
    ///   - items: Array of `Detail`
    ///   - algorithm: The algorithm for reordering items
    func prepareItems(items: [Detail], algorithm: Algorithm) -> [[Detail]]  {
        var colors: [UIColor] = [UIColor.red, UIColor.green, UIColor.gray, UIColor.yellow, .darkGray, .cyan, .link, .purple, .orange, .magenta, .brown]
        
        var items = algorithm(items)
        
        //redistribution colors
        for i in items.indices {
            items[i].color = colors.popLast()!
        }
        
        var rearrange = Array.init(repeating: items, count: items[0].timeOnMachines.count)
        
        for i in 1..<rearrange.count {
            for (j, detailInRow) in rearrange[i].enumerated() {
                let topRow = rearrange[i-1]
                if i > 0 && j == 0 {
                    rearrange[i][j].leftOffset = topRow[0].timeOnMachines[i-1] + topRow[0].leftOffset
                }
            }
        }
        
        return rearrange
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
