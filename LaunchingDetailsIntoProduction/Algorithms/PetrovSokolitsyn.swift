//
//  PetrovSokolitsyn.swift
//  LaunchingDetailsIntoProduction
//
//  Created by Александр Камышев on 22.03.2020.
//  Copyright © 2020 Александр Камышев. All rights reserved.
//

import Foundation


class PetrovSokolitsyn {
    
    //Sum from 0 to n-1 and descending by sum
    static func PetrovSokolitsyn1(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            let firstSum = firstItem.timeOnMachines[0..<firstItem.timeOnMachines.count-1].reduce(0, +)
            let secondSum = secondItem.timeOnMachines[0..<secondItem.timeOnMachines.count-1].reduce(0, +)
            return firstSum < secondSum
       }
    }
    
    //Sum from 1 to n and ascending by sum
    static func PetrovSokolitsyn2(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            let firstSum = firstItem.timeOnMachines[1..<firstItem.timeOnMachines.count].reduce(0, +)
            let secondSum = secondItem.timeOnMachines[1..<secondItem.timeOnMachines.count].reduce(0, +)
            return firstSum > secondSum
       }
    }
    
    //Difference between last and first machines descending by diff
    static func PetrovSokolitsyn3(items: [Detail]) -> [Detail] {
        return items.sorted { (firstItem, secondItem) -> Bool in
            let firstDiff = firstItem.timeOnMachines.last! - firstItem.timeOnMachines.first!
            let secondDiff = secondItem.timeOnMachines.last! - secondItem.timeOnMachines.first!
            return firstDiff > secondDiff
       }
    }
    
}
