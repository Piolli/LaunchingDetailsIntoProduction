//
//  Johnson.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 22.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation

class Johnson {
    
    //Maximum sum of machines' time by descending time
    static func Johnson4(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            let firstSum = firstItem.timeOnMachines.reduce(0, +)
            let secondSum = secondItem.timeOnMachines.reduce(0, +)
            if firstSum == secondSum {
                return firstItem.timeOnMachines[0] < secondItem.timeOnMachines[0]
            }
            return firstSum > secondSum
       }
    }
    
    //Minimum time on first machine by ascending time
    static func Johnson1(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            return firstItem.timeOnMachines[0] < secondItem.timeOnMachines[0]
        }
    }
    
    //Minimum time on last machine by ascending time
    static func Johnson2(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            let lastItemFirst = firstItem.timeOnMachines.last!
            let lastItemSecond = secondItem.timeOnMachines.last!
            
            if lastItemFirst == lastItemSecond {
                return firstItem.timeOnMachines[0] < secondItem.timeOnMachines[0]
            }
            
            return lastItemFirst > lastItemSecond
        }
    }
    
    //Maximum index position of max items, if equal then compare first items in for
    static func Johnson3(items: [Detail]) -> [Detail] {
        //minimum by first machine
        return items.sorted { (firstItem, secondItem) -> Bool in
            let maxIndexFirst = firstItem.timeOnMachines.lastIndex(of: firstItem.timeOnMachines.max()!)!
            let maxIndexSecond = secondItem.timeOnMachines.lastIndex(of: secondItem.timeOnMachines.max()!)!
            if maxIndexFirst == maxIndexSecond {
                for i in firstItem.timeOnMachines.indices {
                    if firstItem.timeOnMachines[i] != secondItem.timeOnMachines[i] {
                        return firstItem.timeOnMachines[i] < secondItem.timeOnMachines[i]
                    }
                }
            }
            return maxIndexFirst > maxIndexSecond
        }
    }
    
    static func Johnson5(items: [Detail]) -> [Detail] {
        let johnsons = [
            Johnson1(items: items).map({$0.number}),
            Johnson2(items: items).map({$0.number}),
            Johnson3(items: items).map({$0.number}),
            Johnson4(items: items).map({$0.number})
        ]
        
        var itemSums: [(index: Int, sum: Int)] = []
        for i in 1...items.count {
            var sumOfItemIndixes = 0
            for john in johnsons {
                sumOfItemIndixes += john.firstIndex(of: i)! + 1
            }
            itemSums.append((i, sumOfItemIndixes))
        }
        
        let ascendingIndexesBySum = itemSums
            .sorted { (item1, item2) -> Bool in
                return item1.sum < item2.sum
            }
            .map({$0.index})
        
        var reorderedByIndexes: [Detail] = []
        
        for index in ascendingIndexesBySum {
            reorderedByIndexes.append(items[index-1])
        }
        
        return reorderedByIndexes
    }

}
