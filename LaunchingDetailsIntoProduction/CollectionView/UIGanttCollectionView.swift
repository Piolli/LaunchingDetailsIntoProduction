//
//  UIGanttCollectionView.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 25.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import UIKit

class UIGanttCollectionView: UICollectionView {

    typealias Algorithm = ([Detail]) -> [Detail]
    
    private let cellIdentifier = "ganttCell"
    private var displayingItems: [[Detail]] = []
    
    var ganttLayout: GanttLayout!
    
    var items: [Detail] = [] {
        didSet {
            updateItems()
        }
    }
    
    var zoomValue: CGFloat = 1.0 {
        didSet {
            ganttLayout.layoutMetrics.scale(to: self.zoomValue)
        }
    }
    
    var reorderingAlgorithm: Algorithm = { $0 } {
       didSet {
            updateItems()
       }
    }
    
    func updateItems() {
        displayingItems = prepareItems(items: self.items, algorithm: reorderingAlgorithm)
        ganttLayout.items = displayingItems
        reloadData()
    }
    
    init(items: [Detail]) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        register(GanttCell.self, forCellWithReuseIdentifier: cellIdentifier)
        ganttLayout = GanttLayout(items: displayingItems)
        self.items = items
        
        setCollectionViewLayout(ganttLayout, animated: true)
        dataSource = self
        delegate = self
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Prepare items for displaying
    /// - Parameters:
    ///   - items: Array of `Detail`
    ///   - algorithm: The algorithm for reordering items
    func prepareItems(items: [Detail], algorithm: Algorithm) -> [[Detail]]  {
        
        if items.count == 0 {
            return [[]]
        }
        
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
    
}

extension UIGanttCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GanttCell
        let item = displayingItems[indexPath.row][indexPath.section]
        cell.backgroundColor = item.color
        cell.addNumberOfTasks(text: "\(item.number), \(item.timeOnMachines[indexPath.row])")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if displayingItems.count > 0 {
            return displayingItems[0].count
        } else {
            return 0
        }
    }
}
