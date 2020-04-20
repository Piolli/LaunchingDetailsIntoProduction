//
//  GanttLayout.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 23.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation
import UIKit

let reorderingAlgorithms: [UIGanttCollectionView.Algorithm] = [
    { $0 }, //without order
    Johnson.Johnson1(items:),
    Johnson.Johnson2(items:),
    Johnson.Johnson3(items:),
    Johnson.Johnson4(items:),
    Johnson.Johnson5(items:),
    PetrovSokolitsyn.PetrovSokolitsyn1(items:),
    PetrovSokolitsyn.PetrovSokolitsyn2(items:),
    PetrovSokolitsyn.PetrovSokolitsyn3(items:)
]

class GanttLayout: UICollectionViewLayout {

    public static let headerDecorationIdentifier = "headerDecoration"
    public static let leadingDecorationIdentifier = "leadingDecoration"
    
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
        var zoomValue: CGFloat = 1
        
        mutating func scale(to value: CGFloat) {
            zoomValue = value
            rowHeight = DefaultLayoutMetrics.rowHeight * value
            cellWidth = DefaultLayoutMetrics.cellWidth * value
            timeHeaderHeight = DefaultLayoutMetrics.timeHeaderHeight * value
        }
    }
    
    ///Emit event if length of layout object did change
    var lenghtOfProductionLineDidChange: ((CGFloat) -> Void)?
    
    var lengthOfProductionLine: CGFloat = 0 {
        didSet {
            lenghtOfProductionLineDidChange?(self.lengthOfProductionLine)
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
        if items.count == 0 {
            print("Count of items is zero")
            return
        }

        var yOffsets: [CGFloat] = [layoutMetrics.timeHeaderHeight]
        for row in 1..<items.count {
            yOffsets.append(layoutMetrics.rowHeight + yOffsets[row-1])
        }
        
        var xoffsets: [CGFloat] = Array.init(repeating: 0, count: items.count)
        var rowIndex = 0
        for itemInRowIndex in 0..<items[rowIndex].count {
            rowIndex = 0
            for _ in 0..<items.count {
                
                let indexPath = IndexPath(row: rowIndex, section: itemInRowIndex)
                let itemAttrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                let item = items[rowIndex][itemInRowIndex]
                
//                print(item)
//                print(indexPath)
//                print("-----")
                
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
                
                // + layoutMetrics.cellWidth – additional leading decoration view
                let frame = CGRect(x: xoffsets[rowIndex] + layoutMetrics.cellWidth, y: yOffsets[rowIndex], width: itemWidth, height: layoutMetrics.rowHeight)
                itemAttrs.frame = frame
                cache[indexPath] = itemAttrs
                
                xoffsets[rowIndex] += itemWidth
                rowIndex += 1
            }
        }
        
        //Length Of Production Line is the last row's length divided on cell width
        let newLength = round(xoffsets.last! / layoutMetrics.cellWidth)
        lengthOfProductionLine = newLength
        if newLength != lengthOfProductionLine {
            invalidateLayout()
        }
        
    }

    override var collectionViewContentSize: CGSize {
        //compute estimated width of max time
        let sectionsCount = collectionView!.numberOfSections
        if sectionsCount == 0 {
            return .zero
        }

        let width = lengthOfProductionLine * layoutMetrics.cellWidth
        let itemsCount = items.count
        let height = layoutMetrics.timeHeaderHeight + (layoutMetrics.rowHeight * CGFloat(itemsCount))
        
        return .init(width: width, height: height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if collectionView!.numberOfSections == 0 {
            return nil
        }
        
        var atts: [UICollectionViewLayoutAttributes] = []
        if let d = layoutAttributesForDecorationView(ofKind: GanttLayout.headerDecorationIdentifier, at: IndexPath(row: 0, section: 0)) {
            if rect.intersects(d.frame) {
                atts.append(d)
            }
        }
        
        if let d = layoutAttributesForDecorationView(ofKind: GanttLayout.leadingDecorationIdentifier, at: IndexPath(row: 0, section: 0)) {
            if rect.intersects(d.frame) {
                atts.append(d)
            }
        }
        
        for (_, layoutAttrs) in cache {
            if rect.intersects(layoutAttrs.frame) {
                atts.append(layoutAttrs)
            }
        }
        
        return atts
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == GanttLayout.headerDecorationIdentifier {
            let attr = GanttHeaderViewLayoutAttributes(forDecorationViewOfKind: GanttLayout.headerDecorationIdentifier, with: indexPath)
            attr.frame = .init(x: layoutMetrics.cellWidth, y: 0, width: collectionViewContentSize.width, height: layoutMetrics.timeHeaderHeight)
            attr.zoomValue = layoutMetrics.zoomValue
            attr.zIndex = 1
            return attr
        }
        else if elementKind == GanttLayout.leadingDecorationIdentifier {
            let attr = GanttHeaderViewLayoutAttributes(forDecorationViewOfKind: GanttLayout.leadingDecorationIdentifier, with: indexPath)
            attr.frame = .init(x: 0, y: 0, width: layoutMetrics.cellWidth, height: collectionViewContentSize.height)
            attr.zoomValue = layoutMetrics.zoomValue
            attr.zIndex = 1
            attr.countOfCells = items.count
            attr.rowHeight = layoutMetrics.rowHeight
            attr.topOffset = layoutMetrics.timeHeaderHeight
            return attr
        }
        return nil
    }
}
